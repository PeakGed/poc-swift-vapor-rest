//
//  File.swift
//  
//
//  Created by IntrodexMac on 29/1/2567 BE.
//

import Foundation
import Vapor
import Fluent

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