import Fluent
import FluentSQL

struct CreateOrderSchema: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("orders")
            .id()
            .field("status",  .sql(raw: "VARCHAR(20)"), .required)
            .field("payment_url",  .sql(raw: "VARCHAR(255)"), .required)
            .field("diskon", .float)
            .field("tax", .float)
            .field("shipping_platform", .string)
            .field("shipping_cost", .float)
            .field("shipping_address", .string)
            .field("shipping_track_id", .string)
            .field("total_product_price", .float)
            .field("grand_total_price", .float)
            .field("collect_self", .bool)
            .field("cart_id", .uuid, .required)
            .field("user_id", .uuid, .required)
            .field("geo_loc_id", .uuid, .required)
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("city", .string)
            .field("province", .string)
            .field("postal_code", .string)
            .field("country", .string)
            .field("mobile_phone", .string, .required)
            .field("billing_address", .string)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("orders").delete()
    }    
}