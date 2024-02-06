//
//  AuthResponse.swift
//  FindCoffee
//
//  Created by Anton on 05.02.24.
//

import Foundation

struct AuthResponse: Codable {
    let token: String
    let tokenLifetime: Int32
}
