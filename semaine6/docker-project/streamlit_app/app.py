import streamlit as st
import pandas as pd
import requests
import matplotlib.pyplot as plt

# Title of the app
st.title('Airbnb Data Visualization')


# Caching the data loading function
@st.cache_data
def load_data() -> pd.DataFrame:
    response = requests.get('http://flask_app:5000/data')
    dataframe = pd.DataFrame(response.json())
    return dataframe


# Convert price to numeric format
def extract_price(price_dict):
    try:
        return float(price_dict["$numberDecimal"])
    except (TypeError, KeyError, ValueError):
        return float('nan')


# Loading data with status update
data_load_state = st.text('Loading data...')
df = load_data()
data_load_state.text('Loading data...done')

# Select relevant columns
keep_col = ['_id', 'name', 'price', 'room_type', 'amenities', 'review_scores']
df = df[keep_col]

# Display the dataframe
st.dataframe(df)

df["numeric_price"] = df['price'].apply(extract_price)
# Plot room type distribution
st.subheader('Room Type Distribution')
chart_data = df['room_type'].value_counts()
st.bar_chart(chart_data)

# histogram for prices
st.title('Price Histogram')
fig, ax = plt.subplots()
num_bins = min(len(df["numeric_price"].dropna().unique()), 25)
st.write(df["numeric_price"].min(),df["numeric_price"].max())
ax.hist(df["numeric_price"], bins=num_bins, color='blue', edgecolor='black')
ax.set_title('Histogram of Prices')
ax.set_xlabel('Price')
ax.set_ylabel('Frequency')
st.pyplot(fig)
