//
//  ErrorMessage.swift
//  CryptoListers
//
//  Created by Vaishnav on 13/05/24.
//

import Foundation

enum ErrorMessage: String, Error {
    
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    
}
