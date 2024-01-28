//
//  File.swift
//
//
//  Created by IntrodexMac on 28/1/2567 BE.
//

import Foundation
import Fluent
import Vapor

final class ProductScheme: Model, Content {
    static let schema = "Products"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "price")
    var price: Double
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "unit")
    var unit: String
    
    init() { }
    
    init(id: UUID? = nil,
         name: String,
         price: Double,
         description: String,
         unit: String) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.unit = unit
    }
    
}
