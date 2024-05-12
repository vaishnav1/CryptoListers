//
//  CryptoListViewController.swift
//  CryptoListers
//
//  Created by Vaishnav on 11/05/24.
//

import UIKit

class CryptoListViewController: UIViewController {
    
    let listTableView = UITableView()
    let searchBar = UISearchController()
    var navBar = UINavigationBar()
    
    // Move this to VM
    var dataModel: [DataResponseModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
//        setNavigationBar()
        setupView()
        setSearchBarController()
        setupTableView()
        makeAPICall()
    }
    
    override func viewWillLayoutSubviews() {
        setNavigationBar()
    }
    
    // MARK: - Setup UI Methods
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 55/255, green: 0/255, blue: 175/255, alpha: 1)
    }
    
    private func setupTableView() {
        view.addSubview(listTableView)
        listTableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: DetailsTableViewCell.reuseId)
        listTableView.dataSource = self
        listTableView.rowHeight = UITableView.automaticDimension
        listTableView.layer.cornerRadius = 12
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        listTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        listTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        listTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setSearchBarController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func setNavigationBar() {
        let width = self.view.frame.width
        navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        let navigationItem = UINavigationItem(title: AppConstants.navigationTitleCoin)
        self.navigationController?.navigationBar.tintColor = .systemBackground
        self.view.addSubview(navBar)
    }
    
    private func makeAPICall() {
        let stringUrl = "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/"
        guard let url = URL(string: stringUrl) else { return }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { Data, ResponseData, Error in
            let jsonDecoder = JSONDecoder()
            do {
                if let safeData = Data {
                    let decodedData = try jsonDecoder.decode([DataResponseModel].self, from: safeData)
                    self.dataModel = decodedData
                    print(decodedData)
                }
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                }
            }
            catch {
                print(Error ?? "Error reading data")
            }
        }.resume()
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
//        NewsService.shared.search(for: searchText) { result in
//            switch result {
//            case .success(let articles):
//                self.articles = articles
//                DispatchQueue.main.async {
//                    self.applySnapshot()
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
