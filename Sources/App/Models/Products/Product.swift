//
//  File.swift
//
//
//  Created by IntrodexMac on 28/1/2567 BE.
//

import Foundation
import Fluent
import Vapor

final class Product: Model, Content {
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
    
    // Reflecting a reference to ProductCategory
    @Parent(key: "category_id")
    var category: ProductCategory
    
    init() { }
    
    init(id: UUID? = nil,
         name: String,
         price: Double,
         description: String,
         unit: String,
         category: ProductCategory) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.unit = unit
        self.$category.id = try! category.requireID()
    }
}

/*
 static func createBuilder(database: Database) -> SchemaBuilder {
     database.schema(Self.schema)
         .id()
         .field("name", .string, .required)
         .field("price", .double, .required)
         .field("description", .string)
         .field("unit", .string, .required)
         .field("category_id", .uuid, .references(ProductCategory.schema, "id"))
         .unique(on: "name")
 }
 */
