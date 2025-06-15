# CountryExplorer

**CountryExplorer** is a beautifully designed iOS application built using **SwiftUI**, **MVVM-C**, and **Clean Architecture**. It allows users to explore countries, search for them by name, automatically detect their current location, and store a personalized list with offline access using Core Data.

---

## Features

* Browse and select countries
* Live search with debounced filtering
* Auto-select user's country using Core Location
* Fallback to Egypt if permission denied or location fails
* Offline support using Core Data
* Dark mode and light mode compatibility
* Clean, accessible UI with support for VoiceOver
* Gradient buttons, shadowed cards, and system-style controls
* All data stored with Core Data and available offline

---

## Architecture

CountryExplorer is structured using **MVVM-C (Model-View-ViewModel-Coordinator)** to promote separation of concerns, testability, and modularity.

```
CountryExplorer/
├── Core
│   ├── Network
│   └── CoreData
├── Data
│   ├── DTOs
│   ├── Local
│   ├── Remote
│   ├── Location
│   └── Mappers
├── Domain
│   ├── Entities
│   └── UseCases
├── Presentation
│   ├── Views
│   └── ViewModels
├── Utilities
└── Resources
```

* **ViewModel**: Drives UI logic, fetches from use cases
* **Use Cases**: Business logic
* **Repositories**: Abstract local/remote data
* **Coordinators**: Handle navigation

Built with:

* SwiftUI (UI)
* Combine + async/await (Data flow)
* Core Data (Persistence)
* CoreLocation (Auto selection)

---

## Testing

* Unit Tests for ViewModels, UseCases, Mappers, DataSources
* Mockable protocols and injected dependencies

To enable coverage:

1. Scheme > Test > Options > ☑ Gather coverage data
2. Run tests with ⌘U
3. View Report Navigator > Coverage tab

---

## How to Run

1. Clone the repo:

```bash
git clone https://github.com/FatmaAnwar/CountryExplorer.git
```

2. Open `CountryExplorer.xcodeproj`
3. Build & run with iOS 16+ simulator

---

## Manual Testing Checklist

* App launches with correct gradient background
* Live search filters accurately
* GPS auto-selection works
* Egypt fallback triggers if permission is denied
* Selected countries saved and persisted
* Offline mode displays cached data
* Full dark mode support across screens

---

## Demo and Screenshots

| Selected countries | Browse countries | Detail View | Search |
|-------------------|--------------------|--------------------------|--------------------------|
| ![Simulator Screenshot - iPhone 16 - 2025-06-15 at 21 19 51](https://github.com/user-attachments/assets/19c3341c-b8f1-4e15-8286-f8c8d6dc1c8d) | ![Simulator Screenshot - iPhone 16 - 2025-06-15 at 21 19 55](https://github.com/user-attachments/assets/21bf0707-a8fb-4842-b303-2fd75ebe4a99) | ![Simulator Screenshot - iPhone 16 - 2025-06-15 at 21 20 09](https://github.com/user-attachments/assets/938152cb-4567-458e-a85f-b70c43910a27) | ![Simulator Screenshot - iPhone 16 - 2025-06-15 at 21 20 22](https://github.com/user-attachments/assets/b6cf5a9e-bc64-44f6-ba4e-a84fb144c77d) |

### Live Demo

https://github.com/user-attachments/assets/604945db-a7dd-4b79-9c7c-c671189a5998

https://github.com/user-attachments/assets/3a7cc5bd-59cd-4ef8-bf18-f76ca4875129

