//
//  AppController.swift
//  WalmartTestProject
//
//  Created by Khurram Nawaz on 6/17/25.
//


@MainActor
class AppController {
    let dataStore: DataStoreService
    private let useCase: FetchCountriesUseCaseService

    init(dataStore: DataStoreService = DataStore(),
         networkingService: NetworkingService = Networking()) {
        self.dataStore = dataStore
        self.useCase = FetchCountriesUseCase(networkingService: networkingService, dataStore: dataStore)
    }

    func fetchCountries(completion: @escaping () -> Void) {
        Task {
            do {
                _ = try await useCase.execute()
                completion()
            } catch {
                print("Error fetching countries: \(error.localizedDescription)")
            }
        }
    }

    func getCountries() async -> [Country] {
        return await dataStore.getCountries()
    }
}

/*

// MARK: - View Controller
class CountryListViewController: UITableViewController, UISearchResultsUpdating {
    private let appController: AppController
    private var filteredCountries: [CountryViewModel] = []
    private var searchController = UISearchController(searchResultsController: nil)

    init(appController: AppController) {
        self.appController = appController
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        setupSearchController()
        fetchCountries()
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name or capital"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func fetchCountries() {
        appController.fetchCountries { [weak self] in
            Task {
                guard let self else { return }
                let countries = await appController.getCountries()
                self.filteredCountries = countries.map { CountryViewModel(from: $0) }
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = filteredCountries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(model.nameRegionCodeLine)\n\(model.capitalLine)"
        return cell
    }

    // MARK: - Search Updating
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            Task {
                let countries = await appController.getCountries()
                filteredCountries = countries.map { CountryViewModel(from: $0) }
                tableView.reloadData()
            }
            return
        }
        Task {
            let allCountries = await appController.getCountries()
            let filtered = allCountries.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.capital.localizedCaseInsensitiveContains(searchText)
            }
            filteredCountries = filtered.map { CountryViewModel(from: $0) }
            tableView.reloadData()
        }
    }
}

// To run this in SceneDelegate:
// let navController = UINavigationController(rootViewController: CountryListViewController(appController: AppController()))
// window.rootViewController = navController
*/
