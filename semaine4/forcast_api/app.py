from flask import Flask, render_template, request
import requests
import datetime

app = Flask(__name__)

API_KEY = 'votre_clés_api'

@app.template_filter('datetimeformat')
def datetimeformat(value):
    return datetime.datetime.fromtimestamp(value).strftime('%Y-%m-%d %H:%M:%S')

@app.route('/')
def home():
    city = request.args.get('city', 'Paris')
    weather_data = get_weather(city)
    return render_template('home.html', weather=weather_data, city=city)

@app.route('/forecast')
def forecast():
    city = request.args.get('city', 'Paris')
    forecast_data = get_forecast(city)
    return render_template('forecast.html', forecast=forecast_data, city=city)

@app.route('/details')
def details():
    city = request.args.get('city', 'Paris')
    weather_data = get_weather(city)
    return render_template('details.html', weather=weather_data, city=city)

def get_weather(city):
    url = f'http://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric&lang=fr'
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        return None

def get_forecast(city):
    url = f'http://api.openweathermap.org/data/2.5/forecast?q={city}&appid={API_KEY}&units=metric&lang=fr'
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        return None

if __name__ == '__main__':
    app.run(debug=True)
