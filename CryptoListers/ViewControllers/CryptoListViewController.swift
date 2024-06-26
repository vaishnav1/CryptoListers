//
//  CryptoListViewController.swift
//  CryptoListers
//
//  Created by Vaishnav on 11/05/24.
//

import UIKit

class CryptoListViewController: UIViewController {
    
    // MARK: - UI Elements
    
    let listTableView = UITableView()
    let spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    
    var dataModel: [DataResponseModel]?
    
    // MARK: - VC Cycle
    
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
        self.title = AppConstants.navigationTitleCoin.rawValue
    }
    
    private func setupTableView() {
        view.addSubview(listTableView)
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: DetailsTableViewCell.reuseId)
        listTableView.rowHeight = UITableView.automaticDimension
        listTableView.layer.cornerRadius = 12
        listTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        setTableViewConstraints()
    }
    
    private func setTableViewConstraints() {
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
        navigationItem.searchController = searchController
    }
    
    private func setNavigationBar() {
        var navBar = UINavigationBar()
        let width = self.view.frame.width
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        navBar.barTintColor = .white
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.sizeToFit()
        self.view.addSubview(navBar)
    }
    
    private func showLoader() {
        spinner.startAnimating()
        listTableView.backgroundView = spinner
    }
    
    private func hideLoader() {
        spinner.stopAnimating()
        listTableView.backgroundView = nil
    }
    
    // MARK: - Network Call
    
    private func makeAPICall() {
        showLoader()
        NetworkService.getCryptoData { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let successData):
                self.dataModel = successData
                reloadTableViewMainThread()
            case .failure(let failure):
                print(failure.rawValue)
                hideLoader()
            }
        }
    }
    
    private func reloadTableViewMainThread() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            hideLoader()
            self.listTableView.reloadData()
        }
    }

}

// MARK: - UITableViewDataSource extension

extension CryptoListViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animator = TableViewAnimator(animation: TableAnimationFactory.makeFadeAnimation(duration: 0.2, delayFactor: 0.01))
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
}

// MARK: - UISearchBarDelegate delegate extension

extension CryptoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            makeAPICall()
        } else {
            dataModel = dataModel?.filter({ $0.name?.localizedCaseInsensitiveContains(searchText) ?? false })
            listTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        makeAPICall()
    }
    
}
