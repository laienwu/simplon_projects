FROM python:3.12-slim


WORKDIR /app

RUN mkdir /db
ADD analyse_script.py /app/analyse_script.py
ADD ./database/sample-airbnb.json /app/sample-airbnb.json

CMD ["python"]