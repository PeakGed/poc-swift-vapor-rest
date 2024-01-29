//
//  File.swift
//
//
//  Created by IntrodexMac on 23/1/2567 BE.
//

import Vapor
  
class LocalProductController: RouteCollection {

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
    func all(req: Request) async throws -> LocalProducts {
        do {
            let query = try req.query.decode(QueryProduct.self)
            
            if let name = query.name {
                // return with filter by name
                let foundProducts = LocalProducts.Stub.applDevices.filter(withName: name)
                return foundProducts
            }
            // return all product
            return LocalProducts.Stub.applDevices
        } catch {
            // return all product
            return LocalProducts.Stub.applDevices
        }
    }
    
    // POST /products
    func create(req: Request) async throws -> LocalProduct {
        // try to decode param by CreateContent
        let content = try req.content.decode(CreateProduct.self)
        
        // validate
        try CreateProduct.validate(content: req)
        
        // load from local
        var loadProducts = try LocalDatastore.shared.load(fileName: "products",
                                                          type: LocalProducts.self)
        let lastedID = loadProducts.latedID()
                
        // new product
        let newProduct = LocalProduct(id: lastedID,
                                 name: content.name,
                                 price: content.price,
                                 description: content.description,
                                 unit: content.unit)
        loadProducts.append(newProduct)
        
        // save to datastore
        try LocalDatastore.shared.save(fileName: "products",
                                       data: loadProducts)
        
        return newProduct
    }
    
    // GET /products/:id
    func getByID(req: Request) async throws -> LocalProduct {
        guard
            let idRaw = req.parameters.get("id"),
            let id = Int(idRaw) 
        else { throw Abort(.badRequest) }
        
        // load from local
        let loadProducts = try LocalDatastore.shared.load(fileName: "products",
                                                          type: LocalProducts.self)
        
        guard 
            let foundProduct = loadProducts.find(id: id)
        else { throw Abort(.notFound) }
        
        return foundProduct
    }
    
    // PUT /products/:id
    func update(req: Request) async throws -> LocalProduct {
        guard
            let idRaw = req.parameters.get("id"),
            let id = Int(idRaw)
        else { throw Abort(.badRequest) }
        
        // try to decode param by CreateContent
        let content = try req.content.decode(UpdateProduct.self)
        
        // validate
        try UpdateProduct.validate(content: req)
        
        // load from local
        var loadProducts = try LocalDatastore.shared.load(fileName: "products",
                                                          type: LocalProducts.self)
        
        guard
            let foundProduct = loadProducts.find(id: id)
        else { throw Abort(.notFound) }
        
        let modifyProduct = LocalProduct(id: id,
                                    name: content.name ?? foundProduct.name,
                                    price: content.price ?? foundProduct.price,
                                    description: content.description ?? foundProduct.description,
                                    unit: content.unit ?? foundProduct.unit)
        
        loadProducts.replace(modifyProduct)
        
        //save to datastore
        try LocalDatastore.shared.save(fileName: "products",
                                       data: loadProducts)
        
        return modifyProduct
    }
    
    // DELETE /products/:id
    func delete(req: Request) async throws -> HTTPStatus {
        guard
            let idRaw = req.parameters.get("id"),
            let id = Int(idRaw)
        else { throw Abort(.badRequest) }
        
        // load from local
        var loadProducts = try LocalDatastore.shared.load(fileName: "products",
                                                          type: LocalProducts.self)
        
        guard
            let _ = loadProducts.find(id: id)
        else { throw Abort(.notFound) }
        
        loadProducts.delete(id: id)
        
        //save to datastore
        try LocalDatastore.shared.save(fileName: "products",
                                       data: loadProducts)
                
        return .ok
    }
}

extension LocalProductController {
    
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


