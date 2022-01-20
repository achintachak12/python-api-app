# To build and push docker image

docker build -t python-flask-api .

docker images

docker login

# Tag the image
docker tag python-flask-api achidoc/python-flask-api:latest

# Push the image to docker hub
# docker push achidoc/python-flask-api:latest

# Push the image to AWS ECR

