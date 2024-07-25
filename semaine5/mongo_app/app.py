from flask import Flask, request, jsonify, render_template, redirect, url_for
from pymongo import MongoClient
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()
usr = os.getenv("mongo_usr")
pwd = os.getenv("mongo_pw")

# Connect to MongoDB
client = MongoClient(f'mongodb://{usr}:{pwd}@localhost:27017/')
db = client["airbnb"]
collection = db["listingsAndReviews"]

app = Flask(__name__)


# Function to find listings with specified amenities in a given city
def find_listings_with_amenities(city, list_amenities):
    query = {
        "address.market": city,
        "amenities": {"$all": list_amenities}
    }
    projection = {
        "listing_url": 1,
        "_id": 0
    }
    results = collection.find(query, projection)
    return [result['listing_url'] for result in results]


# Define the route for the HTML form
@app.route('/')
def index():
    return render_template('index.html')


# Define the route for handling form submissions
@app.route('/amenities', methods=['POST'])
def get_amenities():
    city = request.form.get('city')
    amenities = request.form.get('amenities').split(',')

    if not city or not amenities:
        return jsonify({"error": "City and amenities must be provided"}), 400

    listings_urls = find_listings_with_amenities(city, amenities)

    return render_template('results.html', listing_urls=listings_urls, city=city, amenities=amenities)


if __name__ == '__main__':
    app.run(debug=True)
