# To build and push docker image

# Build the image
docker build -t python-flask-api .

docker images

echo "Now we will tag and putsh the image to Docker Hub"

echo "Please provide your Docker ID"

read did

# Docker login to push the image
docker login -u $did

# Tag the image for docker hub
docker tag python-flask-api $did/python-flask-api:latest

# Push the image to docker hub
docker push $did/python-flask-api:latest


