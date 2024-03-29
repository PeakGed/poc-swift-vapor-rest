import Vapor
import Leaf

func routes(_ app: Application) throws {
    
    switch app.environment {
    case .testing:
        try registerTestingRoutes(app)
        return
    default:
        break
    }
    
    
    app.get { req async in
        "Welcome to Swift Vapor Playground"
    }

    app.get("hello") { req async throws -> View in
        return try await req.view.render("hello", ["name": "Leaf"])
    }
        
    // no auth
    try app.register(collection: AuthController())
    //try app.register(collection: ProductController())
    
    // required auth
    let protected = app.grouped(UserAuthenticator()).grouped(User.guardMiddleware())
    try protected.register(collection: ProductController())
    
    // init stub datasource
    try LocalDatastore.shared.save(fileName: "products",
                                   data: Products.Stub.applDevices)
    
    try LocalDatastore.shared.save(fileName: "users",
                                   data: Users.Stub.allUsers)
    
}

func registerTestingRoutes(_ app: Application) throws {
    // no auth
    try app.register(collection: AuthController())
    try app.register(collection: ProductController())
    
    // init stub datasource
    try LocalDatastore.shared.save(fileName: "products",
                                   data: Products.Stub.applDevices)
    
    try LocalDatastore.shared.save(fileName: "users",
                                   data: Users.Stub.allUsers)
}
