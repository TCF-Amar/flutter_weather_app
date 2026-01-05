# Weather App 🌤️

A modern, feature-rich Flutter weather application that provides real-time weather information with a beautiful, intuitive interface.

## Features ✨

### Core Functionality

- **Current Weather** - Real-time weather data for your current location
- **Hourly Forecast** - 24-hour weather predictions with detailed metrics
- **7-Day Forecast** - Weekly weather outlook with min/max temperatures
- **Multiple Locations** - Save and track weather for multiple locations
- **Location Search** - Search for any city worldwide
- **Auto-location** - Automatic location detection using GPS

### Weather Details

- Temperature (Celsius/Fahrenheit)
- Weather conditions with icons
- Precipitation probability
- Wind speed (km/h, mph, m/s)
- Humidity levels
- UV index
- Sunrise & sunset times
- Atmospheric pressure

### User Experience

- **Dark/Light Mode** - Automatic theme switching
- **Unit Preferences** - Customizable temperature and wind speed units
- **Smooth Animations** - Polished UI with micro-interactions
- **Offline Support** - Cached weather data
- **Recent Searches** - Quick access to previously searched locations

## Tech Stack 🛠️

### Framework & Language

- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language

### State Management

- **GetX** - Reactive state management and dependency injection

### Architecture

- **Clean Architecture** - Separation of concerns with layers:
  - Presentation (Views, Widgets)
  - Domain (Models, Controllers)
  - Data (API, Storage)

### Key Packages

- `dio` - HTTP client for API requests
- `geolocator` - Location services
- `go_router` - Declarative routing
- `shared_preferences` - Local data persistence
- `intl` - Internationalization and date formatting
- `flutter_svg` - SVG rendering
- `dartz` - Functional programming utilities
- `equatable` - Value equality

## Project Structure 📁

```
lib/
├── core/
│   ├── storage/          # Local storage utilities
│   └── utils/            # Helper functions & utilities
├── services/
│   ├── api/              # API service layer
│   └── routes/           # App routing configuration
└── src/
    ├── controllers/      # GetX controllers
    ├── models/           # Data models
    └── views/
        ├── screens/      # App screens
        └── widgets/      # Reusable widgets
            ├── cards/    # Weather cards
            ├── lists/    # List widgets
            └── tiles/    # List item tiles
```

## Getting Started 🚀

### Prerequisites

- Flutter SDK (^3.10.4)
- Dart SDK
- Android Studio / VS Code
- An API key from [Open-Meteo](https://open-meteo.com/) (free, no registration required)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/weather_app.git
   cd weather_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Set up environment variables**

   Create a `.env.development` file in the root directory:

   ```env
   API_BASE_URL=https://api.open-meteo.com/v1
   GEOCODING_API_URL=https://geocoding-api.open-meteo.com/v1
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android

- Minimum SDK: 21
- Target SDK: 34
- Location permissions configured in `AndroidManifest.xml`

#### iOS

- Minimum iOS version: 12.0
- Location permissions configured in `Info.plist`

## API Integration 🌐

This app uses the **Open-Meteo API** - a free, open-source weather API that doesn't require registration.

### Endpoints Used

- Weather Forecast API
- Geocoding API (for location search)

## Configuration ⚙️

### Changing Units

Users can customize units in the Settings screen:

- **Temperature**: Celsius / Fahrenheit
- **Wind Speed**: km/h / mph / m/s

### Theme

The app automatically adapts to system theme preferences.

## Development 👨‍💻

### Code Organization

- **Controllers**: Business logic and state management
- **Models**: Data structures with JSON serialization
- **Views**: UI components (screens and widgets)
- **Services**: External integrations (API, storage)
- **Utils**: Helper functions and utilities

### Key Controllers

- `WeatherController` - Manages weather data
- `LocationController` - Handles GPS and permissions
- `SavedLocationsController` - Manages saved locations
- `SettingsController` - User preferences
- `SearchController` - Location search functionality

## Testing 🧪

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Building for Production 📦

### Android

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments 🙏

- Weather data provided by [Open-Meteo](https://open-meteo.com/)
- Icons and design inspiration from modern weather apps
- Flutter community for excellent packages and support

## Contact 📧

Your Name - [@yourtwitter](https://twitter.com/yourtwitter)

Project Link: [https://github.com/yourusername/weather_app](https://github.com/yourusername/weather_app)

---

Made with ❤️ using Flutter
