//
//  CryptoListViewController.swift
//  CryptoListers
//
//  Created by Vaishnav on 11/05/24.
//

import UIKit

class CryptoListViewController: UIViewController {
    
    let listTableView = UITableView()
    
    // Move this to VM
    var dataModel: [DataResponseModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setupView()
        setSearchBarController()
        setupTableView()
        makeAPICall()
    }
    
    // MARK: - Setup UI Methods
    
    private func setupView() {
        view.backgroundColor = AppColors.themePurple
    }
    
    private func setupTableView() {
        view.addSubview(listTableView)
        listTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: DetailsTableViewCell.reuseId)
        listTableView.dataSource = self
        listTableView.rowHeight = UITableView.automaticDimension
        listTableView.layer.cornerRadius = 12
        listTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        listTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        listTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        listTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setSearchBarController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .prominent
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.layer.cornerRadius = 12
        searchController.searchBar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        searchController.searchBar.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.sizeToFit()
        navigationItem.searchController = searchController
    }
    
    private func setNavigationBar() {
        var navBar = UINavigationBar()
        let width = self.view.frame.width
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        self.title = AppConstants.navigationTitleCoin.rawValue
        navBar.barTintColor = .white
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.view.addSubview(navBar)
    }
    
    // MARK: - Network Call
    
    private func makeAPICall() {
        NetworkService.sharedInstance.getCryptoData { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let successData):
                self.dataModel = successData
                reloadTableViewMainThread()
            case .failure(let failure):
                print(failure.rawValue)
            }
        }
    }
    
    private func reloadTableViewMainThread() {
        DispatchQueue.main.async { [weak self] in
            self?.listTableView.reloadData()
        }
    }

}

// MARK: - UITableViewDataSource extension

extension CryptoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataModel else { return 0 }
        return dataModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.reuseId, for: indexPath) as? DetailsTableViewCell else { return UITableViewCell() }
        guard let dataModel else { return UITableViewCell() }
        cell.configure(with: dataModel[indexPath.row])
        return cell
    }
}

// MARK: - UISearchBarDelegate delegate extension

extension CryptoListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard let searchText = searchBar.text else { return false }
        let filteredModel = dataModel?.filter { $0.name == searchText }
        if let filterData = filteredModel, filterData.count > 0 {
            dataModel = filteredModel
        } else {
            dataModel = nil
            print("No results to display")
        }
        listTableView.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        makeAPICall()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        let filteredModel = dataModel?.filter { $0.name == searchText }
        if let filterData = filteredModel, filterData.count > 0 {
            dataModel = filteredModel
        } else {
            dataModel = nil
            print("No results to display")
        }
        listTableView.reloadData()
    }
}
