import FluentKit

final class FooModel: Model {
     static var schema = "foo_model"
     
     // FIXME: Why is this required, is this common to write it like this?
     init() {}
     init(lastUpdate: Date) {
         self.someDate = lastUpdate
     }
     
     @ID(key: "id") var id: Int
     @Field(key: "some_date") var someDate: Date
 }
 
final class FooMigration: Migration {
     func prepare(on database: Database) -> EventLoopFuture<Void> {
         database.schema("foo_model")
             .field("id", .int, .identifier(auto: true))
             .field("some_date", .json, .required)
             .create()
     }
     
     func revert(on database: Database) -> EventLoopFuture<Void> {
         database.schema("foo_model").delete()
     }
 }
