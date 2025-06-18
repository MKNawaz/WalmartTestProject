# Country Lookup

## Overview

This project provides a Swift-based implementation for fetching country data from a remote API, processing the results, and filtering them based on user input. The architecture follows clean principles with well-separated responsibilities across layers, supporting testability and flexibility. UIKit is used to provide a responsive and accessible UI, and Swift Concurrency (`async/await`) is leveraged for efficient asynchronous programming.

The app also follows a protocol-oriented approach with dependency injection to support modular testing and clear boundaries between components.

## Key Features

- Fetch country data from a remote JSON source.
- Decode and store the received JSON into a Swift model.
- Filter country list dynamically using `UISearchController`.
- Pull to refresh with `UIRefreshControl`.
- Modular architecture based on Clean Architecture principles.
- Dynamic Type support for accessibility.
- Universal layout for iPhone and iPad.
- Multi-orientation support.
- Protocol-based networking and storage interfaces.
- Unit testing readiness for networking, use case, and view controller logic.

## App Demo

- iPhone with Portrait and Landscape Modes

![iPhone](https://github.com/user-attachments/assets/8adc20b9-ebaf-48ce-92a3-9672efcfb8ba)

- 💻 iPad with Multi-Orientation Support

![iPad](https://github.com/user-attachments/assets/3abcdf19-43b4-4473-bdee-6deed58276d7)


---

## 📦 Sample Code Overview

Here is a quick sample to understand the overall flow:

### `AppController`

```swift
class AppController {
    let dataStore: DataStoreProtocol = DataStore()
    private let useCase: FetchCountriesUseCaseProtocol

    init() {
        let networking = NetworkingService()
        self.useCase = FetchCountriesUseCase(networkingService: networking, dataStore: dataStore)
    }

    func fetchCountries(completion: @escaping () -> Void) {
        Task {
            try? await useCase.execute()
            completion()
        }
    }

    func getCountries() async -> [Country] {
        await dataStore.getCountries()
    }
}
```

### `CountryListViewController`

```swift
class CountryListViewController: UIViewController {
    var appController: AppController!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appController.fetchCountries { [weak self] in
            Task {
                self?.countries = await self?.appController.getCountries() ?? []
                self?.tableView.reloadData()
            }
        }
    }
}
```

---

## Project Structure

            [ UI Layer ]
             CountryListViewController
               ↓
            [ Presentation Layer ]
              CountryViewModel
              ↓
            [ Domain Layer ]
              FetchCountriesUseCaseProtocol
              FetchCountriesUseCase
              ↓
            [ Data Layer ]
             NetworkingServiceProtocol
             NetworkingService            ← (fetches from URL)
             DataStoreProtocol
             DataStore                    ← (stores countries)

### 1. Networking Layer

- `NetworkingServiceProtocol` – Defines contract for fetching countries.
- `NetworkingService` – Concrete implementation using URLSession.
- `DataStoreProtocol` – Abstracts the caching interface.
- `DataStore` – Uses `actor` for concurrency-safe in-memory cache.

### 2. Use Case Layer

- `FetchCountriesUseCase` – Fetches and caches country data.

### 3. Presentation Layer

- `CountryViewModel` – Transforms data for display.
- `CountryListViewController` – UI, filtering, and refresh logic.

### 4. Controller

- `AppController` – Composes and wires all components.

---

## 🧪 Unit Testing

- ✅ Mock `NetworkingServiceProtocol` and `DataStoreProtocol`
- ✅ Test `FetchCountriesUseCase` logic independently
- ✅ UI and interaction tests for `CountryListViewController`

### Suggested Tests

- `NetworkingServiceTests` – Simulate success and failure responses
- `UseCaseTests` – Verify logic pipeline
- `ViewControllerTests` – UI response, filtering, and reload behavior

---

## 🚀 How to Run the App

1. Clone this repository.
2. Open the `.xcodeproj` in Xcode.
3. Ensure `CountryListViewController` has its storyboard ID set.
4. In `SceneDelegate.swift` or similar, add:

```swift
let storyboard = UIStoryboard(name: "Main", bundle: nil)
let vc = storyboard.instantiateViewController(withIdentifier: "CountryListViewController") as! CountryListViewController
vc.appController = AppController()
window?.rootViewController = UINavigationController(rootViewController: vc)
```

5. Run the app on Simulator or real device.

---

## 🧪 How to Run the Tests

1. Open project in Xcode.
2. Use **Product > Test** or shortcut **⌘ + U**.
3. Verify test cases pass in the Test navigator.
