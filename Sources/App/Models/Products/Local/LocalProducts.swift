//
//  File.swift
//
//
//  Created by IntrodexMac on 23/1/2567 BE.
//

import Foundation
import Vapor

struct LocalProducts: Codable {
    var lists: [LocalProduct]
    
    init(lists: [LocalProduct]) {
        self.lists = lists
    }

    init(from decoder: Decoder) throws {
        var lists = [LocalProduct]()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let product = try container.decode(LocalProduct.self)
            lists.append(product)
        }
        self.lists = lists
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for product in lists {
            try container.encode(product)
        }
    }
    
    func filter(withName: String) -> LocalProducts {
        let q = withName.lowercased()
        let result = lists.filter { $0.name.lowercased().contains(q) }
        return LocalProducts(lists: result)
    }
    
    func latedID() -> Int {
        let result = lists.sorted { $0.id > $1.id }
        return (result.first?.id ?? 0) + 1
    }
    
    func find(id: Int) -> LocalProduct? {
        return lists.first { $0.id == id }
    }
    
    mutating func append(_ product: LocalProduct) {
        lists.append(product)
    }
    
    mutating func replace(_ product: LocalProduct) {
        guard 
            let index = lists.firstIndex(where: { $0.id == product.id })
        else { return }
        
        lists[index] = product
    }
        
    mutating func delete(id: Int) {
        guard 
            let index = lists.firstIndex(where: { $0.id == id })
        else { return }
        
        lists.remove(at: index)
    }
}

extension LocalProducts: AsyncResponseEncodable {
    func encodeResponse(for request: Request) async throws -> Response {
        let response = Response()
        try response.content.encode(self,
                                    as: .json)
        return response
    }
}

extension LocalProducts: Content {}

extension LocalProducts {
    struct Stub {
        static var applDevices: LocalProducts {
            return LocalProducts(lists: [
                LocalProduct.Stub.ip7,
                LocalProduct.Stub.ip7p,
                LocalProduct.Stub.ip8,
                LocalProduct.Stub.ip8p,
                LocalProduct.Stub.ipx,
                LocalProduct.Stub.ipxs,
                LocalProduct.Stub.ipxsmax,
                LocalProduct.Stub.ipxr,
                LocalProduct.Stub.ip11,
                LocalProduct.Stub.ip11p
            ])
        }
    }
}
