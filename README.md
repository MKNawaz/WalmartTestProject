Country Browser App – README

Overview

This iOS app displays a list of countries fetched from a remote JSON API. Users can search by country name or capital, and pull to refresh the list. The app is designed using Clean Architecture principles with UIKit and Swift Concurrency.

⸻

Data Flow Overview

1. Startup and View Initialization
    •    CountryListViewController is instantiated via Storyboard.
    •    AppController is injected post-instantiation.
    •    On viewDidAppear, it calls fetchCountries().

2. Fetching Data
    •    CountryListViewController → AppController.fetchCountries()
    •    AppController uses a FetchCountriesUseCase object to:
    •    Fetch data via NetworkingService
    •    Store it in DataStore
    •    Completion handler triggers view reload.

3. Search Functionality
    •    Integrated UISearchController listens to user input.
    •    On each keystroke:
    •    updateSearchResults(for:) runs a search against the stored countries.
    •    Filtered results update the table.

4. Pull-to-Refresh
    •    UIRefreshControl is used.
    •    Pulling the list triggers the same AppController.fetchCountries() flow.
    •    Refresh control ends when data is reloaded.

⸻⸻⸻⸻⸻

Architecture
⸻⸻⸻⸻⸻
Clean Architecture-Inspired Layers

[ UI: CountryListViewController ]
         ↓
[ ViewModel: CountryViewModel ]
         ↓
[ Use Case: FetchCountriesUseCase ]
         ↓
[ Repositories: NetworkingService + DataStore ]

⸻⸻⸻⸻⸻⸻⸻

Key Components
    •    CountryListViewController: Displays UI, handles search and refresh
    •    AppController: Coordinates use case and data access
    •    CountryViewModel: Prepares data for display (formatting)
    •    FetchCountriesUseCase: Encapsulates fetching logic
    •    NetworkingService: Fetches raw JSON data using URLSession
    •    DataStore: Stores fetched country data in-memory

⸻⸻⸻⸻⸻⸻⸻
 Dependency Injection
    •    AppController is initialized with NetworkingService and DataStore.
    •    All services are injected via protocols for better testability.

⸻⸻⸻⸻⸻⸻⸻

Testing Suggestions
    •    Mock NetworkingServiceProtocol to test failure/success
    •    Unit test FetchCountriesUseCase
    •    UI test search and refresh interactions
