//
//  ProductControllerTests.swift
//  
//
//  Created by IntrodexMac on 25/1/2567 BE.
//

@testable import App
import XCTVapor

final class ProductControllerTests: XCTestCase {
    
    func testGetAll() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
        
        try app.test(.GET, "products", 
                     afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotNil(res.body)
            
            // expect result is valid
            let expected = try res.content.decode([LocalProduct].self)
            XCTAssertTrue(expected.count > 0)
        })
    }
    
    func testCreate() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
                          
        try app.test(.POST, "products",
                     beforeRequest: { req in
            let newProduct = ProductController.CreateProduct(name: "iPhone 15",
                                                             price: 50000,
                                                             description: "iPhone 15 128GB",
                                                             unit: "THB")
            
            try req.content.encode(newProduct)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotNil(res.body)
            
            // expect result is valid
            let expected = try res.content.decode(LocalProduct.self)
            XCTAssertEqual(expected.name, "iPhone 15")
            XCTAssertEqual(expected.price, 50000)
            XCTAssertEqual(expected.description, "iPhone 15 128GB")
            XCTAssertEqual(expected.unit, "THB")
            
        })
    }
    
    func testGetByID() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
        
        try app.test(.GET, "products/1", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotNil(res.body)
            
            // expect result is valid
            let expected = try res.content.decode(LocalProduct.self)
            XCTAssertEqual(expected.id, 1)
        })
    }
    
    func testUpdate() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
        
        
        
        try app.test(.PUT, "products/1", 
                     beforeRequest: { req in
            let updateProduct = ProductController.UpdateProduct(name: "iPhone XXS")
            try req.content.encode(updateProduct)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotNil(res.body)
            
            // expect result is valid
            let expected = try res.content.decode(LocalProduct.self)
            XCTAssertEqual(expected.name, "iPhone XXS")
        })
    }
    
    func testDelete() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
        
        try app.test(.DELETE, "products/1", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotNil(res.body)
            
        })
    }
    
}
