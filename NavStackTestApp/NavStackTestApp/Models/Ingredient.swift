//
//  Food.swift
//  NavStackTestApp
//
//  Created by Sam.Siamon on 7/1/22.
//

import Foundation

struct Ingredient: Codable, Identifiable, Hashable {
    var name: String
    var id: Int
    var description: String
    var quantinity: Int?

    init(name: String, description: String = "", id: Int, quantinity: Int? = nil) {
        self.name = name
        self.description = description
        self.id = id
        self.quantinity = quantinity
    }
}


