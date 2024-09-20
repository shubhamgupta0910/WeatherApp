# WeatherApp

A simple iOS weather app that allows users to search for cities and view weather forecasts using the OpenWeatherMap API. 
The app is built with the **MVVM** architecture pattern and integrates with the **OpenWeatherMap** API for geocoding and weather forecasting.



https://github.com/user-attachments/assets/285fa0ed-d41a-4c68-b0fa-24cf283fb526



## Features

- Search for cities using the OpenWeatherMap Geocoding API.
- Fetch current weather and 5-day weather forecasts for the selected city.
- Display daily weather for the next 5 days.

## Installation

1. **Clone the repository**:
   git clone https://github.com/shubhamgupta0910/WeatherApp.git
   cd WeatherApp

2. **Install dependencies**:
     pod install

3. **Open the project**:
     open WeatherApp.xcodeproj

4. **Run the project**

## API Integration
The app uses the OpenWeatherMap API to fetch weather data.
Create an account on OpenWeatherMap and obtain your API key.

**Geocoding API**
https://api.openweathermap.org/geo/1.0/direct?q={city}&limit=5&appid={API_KEY}

**Weather Forecast API**
https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API_KEY}&units=metric


## Tests
The project includes unit tests.

**Running Unit Tests**:
    1. Open the project in Xcode.
    2. Select the Test option from the Product menu. 


