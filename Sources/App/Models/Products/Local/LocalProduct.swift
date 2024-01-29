//
//  File.swift
//
//
//  Created by IntrodexMac on 23/1/2567 BE.
//

import Vapor

struct LocalProduct: Codable {
    let id: Int
    let name: String
    let price: Double
    let description: String
    let unit: String
    
    init(id: Int,
         name: String,
         price: Double,
         description: String,
         unit: String) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.unit = unit
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        description = try container.decode(String.self, forKey: .description)
        unit = try container.decode(String.self, forKey: .unit)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
        try container.encode(description, forKey: .description)
        try container.encode(unit, forKey: .unit)
    }    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case price = "price"
        case description = "description"
        case unit = "unit"
    }
}

extension LocalProduct: AsyncResponseEncodable {
    func encodeResponse(for request: Request) async throws -> Response {
        let response = Response()
        try response.content.encode(self,
                                    as: .json)
        return response
    }
}

extension LocalProduct: Content {}

extension LocalProduct {
    struct Stub {
        static var ip7: LocalProduct {
            return LocalProduct(id: 1,
                           name: "iPhone 7",
                           price: 29900,
                           description: "iPhone 7 128GB",
                           unit: "THB")
        }
        
        static var ip7p: LocalProduct {
            return LocalProduct(id: 2,
                           name: "iPhone 7 Plus",
                           price: 34900,
                           description: "iPhone 7 Plus 128GB",
                           unit: "THB")
        }
        
        static var ip8: LocalProduct {
            return LocalProduct(id: 3,
                           name: "iPhone 8",
                           price: 33900,
                           description: "iPhone 8 128GB",
                           unit: "THB")
        }
        
        static var ip8p: LocalProduct {
            return LocalProduct(id: 4,
                           name: "iPhone 8 Plus",
                           price: 38900,
                           description: "iPhone 8 Plus 128GB",
                           unit: "THB")
        }
        
        static var ipx: LocalProduct {
            return LocalProduct(id: 5,
                           name: "iPhone X",
                           price: 44900,
                           description: "iPhone X 128GB",
                           unit: "THB")
        }
        
        static var ipxr: LocalProduct {
            return LocalProduct(id: 6,
                           name: "iPhone XR",
                           price: 34900,
                           description: "iPhone XR 128GB",
                           unit: "THB")
        }
        
        static var ipxs: LocalProduct {
            return LocalProduct(id: 7,
                           name: "iPhone XS",
                           price: 44900,
                           description: "iPhone XS 128GB",
                           unit: "THB")
        }
        
        static var ipxsmax: LocalProduct {
            return LocalProduct(id: 8,
                           name: "iPhone XS Max",
                           price: 49900,
                           description: "iPhone XS Max 128GB",
                           unit: "THB")
        }
        
        static var ip11: LocalProduct {
            return LocalProduct(id: 9,
                           name: "iPhone 11",
                           price: 29900,
                           description: "iPhone 11 128GB",
                           unit: "THB")
        }
        
        static var ip11p: LocalProduct {
            return LocalProduct(id: 10,
                           name: "iPhone 11 Pro",
                           price: 39900,
                           description: "iPhone 11 Pro 128GB",
                           unit: "THB")
        }
    }
}
