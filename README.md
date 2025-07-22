# RESTCountries

A SwiftUI iOS app to search, add, and view country details using the REST Countries API. Built with Clean Architecture, Dependency Injection, and SOLID principles.

## Features
- Search for countries and view their capital and currency
- Add up to 5 countries to your main view
- Remove countries from the main view
- Tap a country for a detailed view
- Automatically adds your country based on GPS (or defaults to Pakistan if denied)
- Offline support: added countries are saved locally
- Unit tested core logic
- **User-friendly:** Shows loading indicator and error messages for network issues

## Architecture
- **Clean Architecture**: Domain, Data, and Presentation layers
- **Dependency Injection**: Protocol-based, testable
- **SOLID Principles**: Modular, maintainable code
- **Repository Pattern**: Data loading policy (local first, then remote) is encapsulated in the repository
- **Async/Await**: Modern concurrency for all data operations
- **Error/Loading Handling**: ViewModel exposes loading and error state for responsive UI

### Folder Structure
```
RESTCountries/
  ├── Domain/         # Entities and protocols
  ├── Data/           # Repositories and services
  └── Presentation/   # SwiftUI views and view models
```

## Setup
1. Clone the repo:
   ```sh
   git clone https://github.com/iAmrSalman/RESTCountries.git
   ```
2. Open `RESTCountries.xcodeproj` in Xcode (15+ recommended).
3. Build and run on Simulator or device.

## Testing
- Unit tests are in the `RESTCountriesTests` target.
- Run tests via Xcode (⌘U) or the Test navigator.

---

**Author:** Amr Salman 
