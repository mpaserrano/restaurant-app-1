const cloudinary = require('cloudinary').v2;
const { CloudinaryStorage } = require('multer-storage-cloudinary');
const multer = require('multer');


cloudinary.config({
    cloud_name: "drsjloigq",
    api_key: "926793658896175",
    api_secret: "5QhoDhOiODpETRSYUrRYDzu5tv0"
});


const storage = new CloudinaryStorage({
    cloudinary,
    params: {
        allowed_formats: ['png', 'jpeg', 'jpg'],
        folder: 'flor-de-sal'
    }
});

module.exports = multer({ storage });