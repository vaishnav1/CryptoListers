//
//  CryptoViewControllerTests.swift
//  CryptoListersTests
//
//  Created by Vaishnav on 13/05/24.
//

import XCTest
@testable import CryptoListers

final class CryptoViewControllerTests: XCTestCase {
    
    var sut: CryptoListViewController!
    var model: DataResponseModel!
    
    override func setUpWithError() throws {
        sut = CryptoListViewController(coder: NSCoder())
        sut.loadViewIfNeeded()
    }
   
    override func tearDownWithError() throws {
        sut = nil
    }
    
}
