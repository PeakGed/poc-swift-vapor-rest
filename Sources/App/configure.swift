import Vapor
import JWT
import Leaf
import Fluent
import FluentMongoDriver

// configures your application
public func configure(_ app: Application) async throws {
        
    switch app.environment {
    case .production:
        print("ENV: production")
        
        if let stage = Environment.get("STAGE") {
            print("STAGE: \(stage)")
        }
        
    case .development:
        print("ENV: development")
        
        if let stage = Environment.get("STAGE") {
            print("STAGE: \(stage)")
        }
    
    case .testing:
        print("ENV: testing")
        
        if let stage = Environment.get("STAGE") {
            print("STAGE: \(stage)")
        }
        
        if let stage = Environment.get("STAGE") {
            print("STAGE: \(stage)")
        }
        
    default:
        break
    }
    
    try app.databases.use(.mongo(connectionString: getMongoDBURLPath()),
                          as: .mongo)
    
    app.jwt.signers.use(.hs256(key: getJWTKey()))
    app.views.use(.leaf)
    
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
    
    // Configure migrations
    //app.migrations.add(CollectionMigration(), to: .mongo)
//    app.migrations.add(CollectionMigration())
//    try await app.autoMigrate()
}

private func getJWTKey() -> String {
    let _defaultKey = "Ddk_JfGFRFde7eOW71DX8-0RnAvN1741rFme3ESBE2A="
    return Environment.get("JWT_KEY") ?? _defaultKey
}

//"mongodb://username:password@host:port/database"
private func getMongoDBURLPath() -> String {
    "mongodb://localhost:27017/MyDB"
    //"mongodb://host.docker.internal:27017/MyDB"
}
