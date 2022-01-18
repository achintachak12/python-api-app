# To build and push docker image

docker build -t python-flask-api .

docker images

docker login

docker tag python-flask-api achidoc/python-flask-api:latest

docker push achidoc/python-flask-api:latest
