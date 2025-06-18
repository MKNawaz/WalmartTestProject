//
//  CountryListViewController.swift
//  WalmartTestProject
//
//  Created by Khurram Nawaz on 6/17/25.
//
import UIKit

class CountryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var appController: AppController!
    
    @IBOutlet weak var countryListTableView: UITableView!
    
    private var filteredCountries: [CountryViewModel] = []
    private var searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
        setupTableView()
        setupSearchController()
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCountries()
    }
    
    // MARK: - UI -

    private func setupTableView() {
        countryListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        countryListTableView.delegate = self
        countryListTableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        countryListTableView.refreshControl = refreshControl
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name or capital"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    // MARK: - Actions -

    private func fetchCountries() {
        appController.fetchCountries { [weak self] in
            Task {
                guard let self else { return }
                let countries = await self.appController.getCountries()
                self.filteredCountries = countries.map { CountryViewModel(from: $0) }
                self.countryListTableView.reloadData()
            }
        }
    }
    
    @objc private func handleRefresh() {
        appController.fetchCountries { [weak self] in
            Task {
                guard let self else { return }
                let countries = await self.appController.getCountries()
                self.filteredCountries = countries.map { CountryViewModel(from: $0) }
                self.countryListTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

    // MARK: - Table View -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = filteredCountries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(model.nameRegionCodeLine)\n\(model.capitalLine)"
        return cell
    }

   
   
}


// MARK: - Search -

extension CountryListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            Task {
                let countries = await appController.getCountries()
                filteredCountries = countries.map { CountryViewModel(from: $0) }
                countryListTableView.reloadData()
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
            countryListTableView.reloadData()
        }
    }
}
