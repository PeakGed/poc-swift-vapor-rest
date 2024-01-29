//
//  File.swift
//  
//
//  Created by IntrodexMac on 29/1/2567 BE.
//

import Foundation
import Vapor
import Fluent

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



