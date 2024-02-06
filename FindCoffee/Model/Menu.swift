//
//  Menu.swift
//  FindCoffee
//
//  Created by Anton on 05.02.24.
//

import Foundation

struct Menu: Decodable {
    let id: Int
    let name: String
    let imageURL: String
    let price: Int
}
