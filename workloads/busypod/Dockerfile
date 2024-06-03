FROM python:3.12.3-alpine3.20

WORKDIR /usr/src/app

COPY busycontainer.py ./

ENTRYPOINT ["python3", "./busycontainer.py"]
CMD ["10000", "5", "otime=60"]
