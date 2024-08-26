# python base image
FROM python:3.12-slim

#set working directory
WORKDIR /app

#copy local file to container and run install panda
COPY csv_generate.py /app/
RUN pip install pandas

#run script
CMD ["python", "csv_generate.py"]