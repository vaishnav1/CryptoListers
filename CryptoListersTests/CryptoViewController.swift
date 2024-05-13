//
//  CryptoViewControllerTests.swift
//  CryptoListersTests
//
//  Created by Vaishnav on 13/05/24.
//

import XCTest
@testable import CryptoListers

class CryptoViewControllerTests: XCTestCase {
    
    var view: CryptoListViewController!
    let dataModelMock: [DataResponseModel] = [DataResponseModel(name: "Bitcoin", symbol: "BTC", isNew: false, isActive: true, type: .coin), DataResponseModel(name: "Ethereum", symbol: "ETH", isNew: false, isActive: true, type: .token)]
    
    override func setUp() {
        super.setUp()
        let vc = CryptoListViewController()
        vc.dataModel = dataModelMock
        view = vc
        _ = view.view
    }
    
    override func tearDown() {
        view = nil
    }
    
    func testViewControllerExist () {
        XCTAssertNotNil(view, "View Controller doesn't exist")
    }
    
    func testViewDidLoad() {
        view.viewDidLoad()
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(view.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(view.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(view.responds(to: #selector(view.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(view.responds(to: #selector(view.tableView(_:cellForRowAt:))))
        XCTAssertTrue(view.responds(to: #selector(view.tableView(_:willDisplay:forRowAt:))))
    }
    
    func testSearchBarTextDidChange() {
        XCTAssertTrue(view.responds(to: #selector(view.searchBar(_:textDidChange:))))
        XCTAssertTrue(view.responds(to: #selector(view.searchBarCancelButtonClicked(_:))))
    }
    
    func testTableCellReuseIdentifier() {
        let cell = view.tableView(view.listTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? DetailsTableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = DetailsTableViewCell.reuseId
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
}
