#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $script_dir/k8s

kubectl delete all --all

kubectl apply -f back-service.yaml

# Get the service name from the argument or use a default
BACKEND_SERVICE_NAME=${1:-backend-service}

# Grab the ClusterIP or External IP from the service using kubectl
BACKEND_SERVICE_IP=$(kubectl get svc $BACKEND_SERVICE_NAME -o jsonpath='{.spec.clusterIP}')

# If External IP exists, fetch it
BACKEND_EXTERNAL_IP=$(kubectl get svc $BACKEND_SERVICE_NAME -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)

# If external IP is not available, fallback to ClusterIP
if [[ -z "$BACKEND_EXTERNAL_IP" ]]; then
  BACKEND_IP=$BACKEND_SERVICE_IP
else
  BACKEND_IP=$BACKEND_EXTERNAL_IP
fi

# Clear or create the Dockerfile
> $script_dir/client/Dockerfile

# Create the Dockerfile content
client_content=$(cat <<-EOF
FROM node:18-alpine AS build

COPY . .

RUN npm install

ENV VITE_SERVER_URL=http://${BACKEND_IP}

RUN npm run build

#############################################

FROM nginx:alpine

COPY --from=build /dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF
)

# Write the Dockerfile content
echo "$client_content" >> $script_dir/client/Dockerfile

# Change to the client directory
cd $script_dir/client

# Build and push the Docker image
docker build -t mpaserrano/restaurant-client . --push

# Output the Dockerfile content for verification
echo "$client_content"

echo "............ BUILDING ............"

cd $script_dir/k8s

echo "creating database . . . "
kubectl apply -f db-pv.yaml
kubectl apply -f db-pvc.yaml
kubectl apply -f db-dpl.yaml

echo "setting up database . . . "

sleep 5

kubectl apply -k .

# Get the service name from the argument or use a default
CLIENT_SERVICE_NAME=${1:-client-service}

# Grab the ClusterIP or External IP from the service using kubectl
CLIENT_SERVICE_IP=$(kubectl get svc $CLIENT_SERVICE_NAME -o jsonpath='{.spec.clusterIP}')

echo "Client: $CLIENT_SERVICE_IP"

