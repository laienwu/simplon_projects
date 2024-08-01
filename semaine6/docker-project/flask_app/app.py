import os

from flask import Flask
from pymongo import MongoClient
from bson.json_util import dumps


app = Flask(__name__)
app.config["CACHE_TYPE"] = "null"
mongo_uri = os.getenv('MONGO_URI')
client = MongoClient(mongo_uri)
db = client["airbnb"]
collection = db["listingsAndReviews"]


@app.route("/")
def index():
    return "we use flask as api endpoints provider, so you won't find any renders here"


@app.route('/data')
def get_data():
    data = dumps(collection.find())
    return data

#todo add query input option


if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)
