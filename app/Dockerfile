FROM python:3.7

WORKDIR /opt/app

COPY ./python ./python

RUN pip install --no-cache-dir -r ./python/requirements.txt

EXPOSE 8080

CMD ["python3", "./python/app.py"]
