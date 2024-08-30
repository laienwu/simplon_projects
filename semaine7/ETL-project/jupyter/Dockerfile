FROM python:3.12-slim

WORKDIR /home/work

COPY requirements.txt /home/work/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--notebook-dir=/home/work"]