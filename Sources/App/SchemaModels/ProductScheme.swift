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
    static let schema = "products"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "email")
    var email: String

    init() { }

    init(id: UUID? = nil, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}
