//
//  File.swift
//
//
//  Created by IntrodexMac on 23/1/2567 BE.
//

import Vapor
import Fluent

class ProductController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        
        let products = routes.grouped("products")
        products.get(use: all)
        products.post(use: create)
        
        products.group(":id") { productWithID in
            productWithID.get(use: getByID)
            productWithID.put(use: update)
            productWithID.delete(use: delete)
        }
    }
    
    // GET /products
    func all(req: Request) async throws -> [Product] {
        do {
            let query = try req.query.decode(QueryProduct.self)
            
            if let name = query.name {
                // return with filter by name
                return try await Product.query(on: req.db)
                    .filter(\.$name =~ name)
                    .all()
            }
            // return all product
            return try await Product.query(on: req.db).all()
        } catch {
            return try await Product.query(on: req.db).all()
        }
    }
    
    // POST /products
    func create(req: Request) async throws -> Product {
        // try to decode param by CreateContent
        let content = try req.content.decode(CreateProduct.self)
        
        // validate
        try CreateProduct.validate(content: req)
        
        let newProduct = Product(name: content.name,
                                       price: content.price,
                                       description: content.description,
                                       unit: content.unit)
        try await newProduct.create(on: req.db)
        
        return newProduct
    }
    
    // GET /products/:id
    func getByID(req: Request) async throws -> Product {
        guard
            let id = req.parameters.get("id"),
            let uuid = UUID(id)
        else { throw Abort(.badRequest) }
        
        do {
            guard
                let product = try await Product.query(on: req.db)
                .filter(\.$id == uuid)
                .first()
            else { throw Abort(.notFound) }
            
            return product
        } catch {
            throw Abort(.notFound)
        }
    }
    
    // PUT /products/:id
    func update(req: Request) async throws -> Product {
        guard
            let id = req.parameters.get("id"),
            let uuid = UUID(id)
        else { throw Abort(.badRequest) }
        
        // try to decode param by UpdateProduct
        let content = try req.content.decode(UpdateProduct.self)
        
        // validate
        try UpdateProduct.validate(content: req)
        
        let updateBuilder = updateProductFieldsBuilder(uuid: uuid,
                                                    content: content,
                                                    db: req.db)
        try await updateBuilder.update()
                
        do {
            guard
                let product = try await getByIDBuilder(uuid: uuid,
                                                       db: req.db).first()
            else { throw Abort(.notFound) }
            
            return product
        } catch {
            throw Abort(.notFound)
        }
    }
    
    // DELETE /products/:id
    func delete(req: Request) async throws -> HTTPStatus {
        guard
            let id = req.parameters.get("id"),
            let uuid = UUID(id)
        else { throw Abort(.badRequest) }
        
        do {
            guard
                let product = try await getByIDBuilder(uuid: uuid,
                                                       db: req.db).first()
            else { throw Abort(.notFound) }
            
            try await product.delete(on: req.db)
        } catch {
            throw Abort(.notFound)
        }
                
        return .ok
    }
}

private extension ProductController {
    
    // Helper function to update product fields in the database
    func updateProductFieldsBuilder(uuid: UUID,
                                    content: UpdateProduct,
                                    db: Database) -> QueryBuilder<Product> {
        let updateBuilder = Product.query(on: db).filter(\.$id == uuid)
        
        if let name = content.name {
            updateBuilder.set(\.$name, 
                               to: name)
        }
        if let price = content.price {
            updateBuilder.set(\.$price, 
                               to: price)
        }
        if let description = content.description {
            updateBuilder.set(\.$description, 
                               to: description)
        }
        if let unit = content.unit {
            updateBuilder.set(\.$unit, 
                               to: unit)
        }
        return updateBuilder
    }
    
    func getByIDBuilder(uuid: UUID,
                        db: Database) -> QueryBuilder<Product> {
        return Product.query(on: db).filter(\.$id == uuid)
    }
}

extension ProductController {
    
    struct QueryProduct: Content {
        let name: String?
    }
    
    struct RequestParameter: Content {
        let id: Int
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let _id = try container.decode(String.self,
                                           forKey: .id)
            guard
                let id = Int(_id)
            else { throw Abort(.badRequest) }
            
            self.id = id
        }
    }
    
    struct CreateProduct: Content, Validatable {
        let name: String
        let price: Double
        let description: String
        let unit: String
        
        init(name: String,
             price: Double,
             description: String,
             unit: String) {
            self.name = name
            self.price = price
            self.description = description
            self.unit = unit
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self,
                                             forKey: .name)
            self.price = try container.decode(Double.self,
                                              forKey: .price)
            self.description = (try? container.decode(String.self,
                                                    forKey: .description)) ?? ""
            self.unit = (try? container.decodeIfPresent(String.self,
                                                        forKey: .unit)) ?? "THB"
        }
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case price = "price"
            case description = "des"
            case unit = "unit"
        }
     
        static func validations(_ validations: inout Validations) {
            validations.add("name", as: String.self,
                            is: .count(3...))
            validations.add("price", as: Double.self,
                            is: .range(0...))
            validations.add("des", as: String.self,
                            is: .count(3...),
                            required: false)
            validations.add("unit", as: String.self,
                            is: .count(3...),
                            required: false)
        }
    }
    
    struct UpdateProduct: Content, Validatable {
        let name: String?
        let price: Double?
        let description: String?
        let unit: String?
        
        init(name: String? = nil,
             price: Double? = nil,
             description: String? = nil,
             unit: String? = nil) {
            self.name = name
            self.price = price
            self.description = description
            self.unit = unit
        }
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case price = "price"
            case description = "des"
            case unit = "unit"
        }
     
        static func validations(_ validations: inout Validations) {
            validations.add("name", as: String.self,
                            is: .count(3...),
                            required: false)
            validations.add("price", as: Double.self,
                            is: .range(0...),
                            required: false)
            validations.add("des", as: String.self,
                            is: .count(3...),
                            required: false)
            validations.add("unit", as: String.self,
                            is: .count(3...),
                            required: false)
        }
    }
    
}


