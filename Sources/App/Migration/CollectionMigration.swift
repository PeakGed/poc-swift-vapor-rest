//
//  File.swift
//  
//
//  Created by IntrodexMac on 29/1/2567 BE.
//

import Foundation
import Vapor
import Fluent

struct CollectionMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        // Create ProductCategories collection
        try await ProductCategorySchema.createBuilder(database: database).create()
        
        // Create Products collection
        try await ProductSchema.createBuilder(database: database).create()
    }
    
    func revert(on database: Database) async throws {
        // Drop ProductCategories collection
        try await database.schema("ProductCategories").delete()
        
        // Drop Products collection
        try await database.schema("Products").delete()
    }
}

/*
 
 class ProductCategorySchema {
     let schema: String = "ProductCategories"
     
     func createBuilder(req: Request) -> SchemaBuilder {
         req.db.schema(schema)
             .id()
             .field("name", .string, .required)
             .field("product_ids", .array(of: .uuid))
             .unique(on: "name")
     }
 }
 
 class ProductSchema {
     let schema: String = "Products"
     
     func createBuilder(req: Request) -> SchemaBuilder {
         req.db.schema(schema)
             .id()
             .field("name", .string, .required)
             .field("price", .double, .required)
             .field("description", .string)
             .field("unit", .string, .required)
             .unique(on: "name")
     }
     
 }

 
 */
