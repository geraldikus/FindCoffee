//
//  Location.swift
//  FindCoffee
//
//  Created by Anton on 05.02.24.
//

import Foundation

struct Location: Decodable {
    let id: Int
    let name: String
    let point: Point
}
