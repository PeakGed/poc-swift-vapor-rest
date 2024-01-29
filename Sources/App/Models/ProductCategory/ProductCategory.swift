//
//  File.swift
//  
//
//  Created by IntrodexMac on 29/1/2567 BE.
//

import Foundation
import Vapor
import Fluent

final class ProductCategory: Model, Content {
    static let schema = "ProductCategories"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    // Reflecting an array of product IDs
    @Field(key: "product_ids")
    var productIds: [UUID]
    
    init() { }

    init(id: UUID? = nil, 
         name: String,
         productIds: [UUID] = []) {
        self.id = id
        self.name = name
        self.productIds = productIds
    }
}
