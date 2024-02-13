//
//  Array.swift
//  FindCoffee
//
//  Created by Anton on 13.02.24.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
