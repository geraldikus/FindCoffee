//
//  NetworkError.swift
//  FindCoffee
//
//  Created by Anton on 05.02.24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidToken
}
