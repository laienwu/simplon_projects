from dotenv import load_dotenv
import os
from pymongo import MongoClient, InsertOne
from bson.json_util import loads


if __name__ == '__main__':
    load_dotenv()
    usr = os.getenv("MONGO_USR")
    pwd = os.getenv("MONGO_PW")
    with MongoClient(f'mongodb://{usr}:{pwd}@mongodb:27017/') as client:
        db = client["airbnb"]
        collection = db["listingsAndReviews"]

        if "listingsAndReviews" in client.airbnb.list_collection_names():
            client.airbnb.listingsAndReviews.drop()

        collection = client.airbnb.listingsAndReviews
        result = []
        with open('listingsAndReviews.json', 'r', encoding='utf8') as f:
            for jsonObj in f:
                try:
                    my_json = loads(jsonObj)
                    result.append(InsertOne(my_json))
                except Exception as e:
                    print(f"Error processing JSON: {e.args}")

        collection.bulk_write(result)
        print(collection.count_documents({}))

