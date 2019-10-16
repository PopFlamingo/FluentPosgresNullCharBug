import Foundation
import FluentKit
import FluentPostgresDriver

let hostname = ProcessInfo.processInfo.environment["HOSTNAME"]!
let port = Int(ProcessInfo.processInfo.environment["PORT"]!)!
let username = ProcessInfo.processInfo.environment["USERNAME"]!
let password = ProcessInfo.processInfo.environment["PASSWORD"] ?? ""
let database = ProcessInfo.processInfo.environment["DATABASE"]!

let elg = MultiThreadedEventLoopGroup(numberOfThreads: 4)
var dbs = Databases(on: elg.next())
defer {
    try! dbs.close().wait()
}
dbs.postgres(config: PostgresConfiguration(hostname: hostname, port: port, username: username, password: password, database: database))

var migrations = Migrations()
migrations.add(FooMigration())
let migrator = Migrator(databases: dbs, migrations: migrations, on: dbs.eventLoop)

_ = try! migrator.setupIfNeeded().and(migrator.prepareBatch()).wait()

_ = try! FooModel(lastUpdate: Date()).save(on: dbs.default()).wait()
