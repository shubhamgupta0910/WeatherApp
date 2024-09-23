# WeatherApp

A simple iOS weather app that allows users to search for cities and view weather forecasts using the OpenWeatherMap API. 
The app is built with the **MVVM** architecture pattern and integrates with the **OpenWeatherMap** API for geocoding and weather forecasting.

## Screenshots & Demo Video

<img src="https://github.com/user-attachments/assets/a3c1d8e2-c522-4763-8253-44530d216c36" alt="App Screenshot" width="300"/>
<img src="https://github.com/user-attachments/assets/1e6ed919-b72b-41a4-ba4f-d26c94c03a62" alt="App Screenshot" width="300"/>

https://github.com/user-attachments/assets/285fa0ed-d41a-4c68-b0fa-24cf283fb526


## Features

- Search for cities using the OpenWeatherMap Geocoding API.
- Fetch current weather and 5-day weather forecasts for the selected city.
- Display daily weather for the next 5 days.

## Technologies Used

- **Swift 5**: Programming language for iOS development.
- **UIKit**: Used for building the user interface.
- **MVVM Architecture**: To ensure separation of concerns and a scalable design.
- **OpenWeatherMap API**: For fetching weather and forecast data.
- **URLSession**: To handle network requests.
- **XCTest**: For writing unit tests.

## Prerequisites

- **Xcode 12.0+**: Ensure you have Xcode installed on your machine.
- **iOS 13.0+**: The app targets iOS 13 and above.
- **OpenWeatherMap API Key**: You will need an API key from OpenWeatherMap.

## How to Setup and Build
Open a terminal and run the following command to clone the project:

1. **Clone the repository**:
   - git clone https://github.com/shubhamgupta0910/WeatherApp.git
   - cd WeatherApp

2. **Install dependencies**:
     pod install

3. **Build and Run the Project:**:
     open WeatherApp.xcworkspace

4. **Run the project**
   In Xcode:

   1. Select the target simulator or device.
   2. Click Run (or use the shortcut Cmd + R).
      
The app will launch, allowing you to search for cities and view weather data.

## How to Generate Test Report
This project includes unit tests to validate the functionality of the ViewModel classes and their interaction with the WeatherService.

   **Running Tests**:
   1. Open Xcode.
   2. Select the Test option from the Product menu or press Cmd + U.

   **Generate Test Reports**:
   To generate a test coverage report:

   Go to **Xcode -> Preferences -> Locations**.
   Under Derived Data, click the arrow to open the derived data folder.
   Once the tests run, a test report will be available inside the DerivedData directory.

## API Integration
The app uses the OpenWeatherMap API to fetch weather data.
Create an account on OpenWeatherMap and obtain your API key.

**Geocoding API**
https://api.openweathermap.org/geo/1.0/direct?q={city}&limit=5&appid={API_KEY}

**Weather Forecast API**
https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API_KEY}&units=metric

## Approach
**Project Architecture: MVVM Pattern**
The Model-View-ViewModel (**MVVM**) pattern was chosen for this project to improve separation of concerns, testability, and maintainability.

**Handling APIs**:
- All the network requests are handled in a separate **WeatherService** class to isolate the networking logic. This improves testability and follows the Single Responsibility Principle.
- The **OpenWeatherMap** API is used for both **geocoding** and **weather data**. 

**Data Parsing and Processing**:
The app processes the weather forecast by grouping the data into daily summaries. The ViewModel manages the transformation of raw API data into a format suitable for UI display (e.g., calculating daily min/max temperatures).
   
**Error Handling**:
Error handling is done using callback closures. If there is an error, ensuring that error messages can be displayed to the user.

