#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $script_dir/k8s

kubectl delete all --all
kubectl delete ingress --all
kubectl delete pvc --all
kubectl delete pv --all

kubectl apply -f back-service.yaml
kubectl apply -f client-service.yaml

# Get the service name from the argument or use a default
BACKEND_SERVICE_NAME=${1:-backend-service}

# Grab the ClusterIP or External IP from the service using kubectl
BACKEND_SERVICE_IP=$(kubectl get svc $BACKEND_SERVICE_NAME -o jsonpath='{.spec.clusterIP}')

# If External IP exists, fetch it
BACKEND_EXTERNAL_IP=$(kubectl get services | grep backend-service | awk '{print $4}')


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

ENV VITE_SERVER_URL=http://$BACKEND_IP

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

kubectl apply -k .

# Get the service name from the argument or use a default
CLIENT_SERVICE_NAME=${1:-client-service}

# Grab the ClusterIP or External IP from the service using kubectl
CLIENT_INTERNAL_IP=$(kubectl get svc $CLIENT_SERVICE_NAME -o jsonpath='{.spec.clusterIP}')

CLIENT_EXTERNAL_IP=$(kubectl get svc $CLIENT_SERVICE_NAME -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

echo -e "Client: \n Internal IP: $CLIENT_INTERNAL_IP \n External IP: $CLIENT_EXTERNAL_IP"

