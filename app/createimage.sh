# To build and push docker image

docker build -t python-flask-api .

docker images

docker login

docker tag python-flask-api apps/python-flask-api

docker push apps/python-flask-api