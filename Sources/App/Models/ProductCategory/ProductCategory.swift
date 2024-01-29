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
    
    init() { }

    init(id: UUID? = nil, 
         name: String) {
        self.id = id
        self.name = name
    }
}
