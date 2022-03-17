import Vapor
import Fluent

final class Order: Model, Content, Codable {
    static let schema = "orders"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "status")
    var status: String

    @Field(key:"payment_url")
    var payment_url: String

    @Field(key: "diskon")
    var diskon: Float?

    @Field(key: "tax")
    var tax: Float?

    @Field(key: "shipping_platform")
    var shipping_platform: String?

    @Field(key: "shipping_cost")
    var shipping_cost: Float?

    @Field(key: "shipping_address")
    var shipping_address: String?

    @Field(key: "shipping_track_id")
    var shipping_track_id: String?

    @Field(key: "total_product_price")
    var total_product_price: Float?

    @Field(key: "grand_total_price")
    var grand_total_price: Float?

    @Field(key: "collect_self")
    var collect_self: Bool?

    @Field(key: "cart_id")
    var cart_id: UUID

    @Field(key: "user_id")
    var user_id: UUID

    @Field(key: "geo_loc_id")
    var geo_loc_id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "email")
    var email: String

    @Field(key: "city")
    var city: String?

    @Field(key: "province")
    var province: String?

    @Field(key: "postal_code")
    var postal_code: String?

    @Field(key: "country")
    var country: String?

    @Field(key: "mobile_phone")
    var mobile_phone: String

    @Field(key: "billing_address")
    var billing_address: String?

    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updated_at: Date?
    
    init() { }
    
    init(id: UUID? = nil,
         status: String,
         payment_url: String,
         diskon: Float?,
         tax: Float?,
         shipping_platform: String?,
         shipping_cost: Float?,
         shipping_address: String?,
         shipping_track_id: String?,
         total_product_price: Float?,
         grand_total_price: Float?,
         collect_self: Bool?,
         cart_id: UUID,
         user_id: UUID,
         geo_loc_id: UUID?,
         name: String,
         email: String,
         city: String?,
         province: String?,
         postal_code: String?,
         country: String?,
         mobile_phone: String,
         billing_address: String?,
         created_at: Date?,
         updated_at: Date?) {
        self.id = id
        self.status = status
        self.payment_url = payment_url
        self.diskon = diskon
        self.tax = tax
        self.shipping_platform = shipping_platform
        self.shipping_cost = shipping_cost
        self.shipping_address = shipping_address
        self.shipping_track_id = shipping_track_id
        self.total_product_price = total_product_price
        self.grand_total_price = grand_total_price
        self.collect_self = collect_self
        self.cart_id = cart_id
        self.user_id = user_id
        self.geo_loc_id = geo_loc_id
        self.name = name
        self.email = email
        self.city = city
        self.province = province
        self.postal_code = postal_code
        self.country = country
        self.mobile_phone = mobile_phone
        self.billing_address = billing_address
        self.created_at = created_at
        self.updated_at = updated_at
    }

    final class CheckId: Content, Codable {
        var user_id: UUID

        init(user_id: UUID){
            self.user_id = user_id
        }
    }

    final class CheckNumber: Content, Codable {
        var num: Int

        init(num: Int){
            self.num = num
        }
    }
}

final class OrderUpdate: Content, Codable {
    
    var status: String?
    var payment_url: String?
    var diskon: Float?
    var tax: Float?
    var shipping_platform: String?
    var shipping_cost: Float?
    var shipping_address: String?
    var shipping_track_id: String?
    var total_product_price: Float?
    var grand_total_price: Float?
    var collect_self: Bool?
    var geo_loc_id: UUID?
    var name: String?
    var email: String?
    var city: String?
    var province: String?
    var postal_code: String?
    var country: String?
    var mobile_phone: String?
    var billing_address: String?
    var created_at: Date?
    var updated_at: Date?

    init(status: String?,
         payment_url: String?,
         diskon: Float?,
         tax: Float?,
         shipping_platform: String?,
         shipping_cost: Float?,
         shipping_address: String?,
         shipping_track_id: String?,
         total_product_price: Float?,
         grand_total_price: Float?,
         collect_self: Bool?,
         geo_loc_id: UUID? = nil,
         name: String?,
         email: String?,
         city: String?,
         province: String?,
         postal_code: String?,
         country: String?,
         mobile_phone: String?,
         billing_address: String?,
         created_at: Date?,
         updated_at: Date?) {
        self.status = status
        self.payment_url = payment_url
        self.diskon = diskon
        self.tax = tax
        self.shipping_platform = shipping_platform
        self.shipping_cost = shipping_cost
        self.shipping_address = shipping_address
        self.shipping_track_id = shipping_track_id
        self.total_product_price = total_product_price
        self.grand_total_price = grand_total_price
        self.collect_self = collect_self
        self.geo_loc_id = geo_loc_id
        self.name = name
        self.email = email
        self.city = city
        self.province = province
        self.postal_code = postal_code
        self.country = country
        self.mobile_phone = mobile_phone
        self.billing_address = billing_address
        self.created_at = created_at
        self.updated_at = updated_at
    }
}

final class OrderLanding: Content, Codable {
    var title: String

    init(title: String) {
        self.title = title
    }
}



extension Order {
    func convertToPublic() -> Order.CheckId {
        return Order.CheckId(user_id: user_id)
    }
}

extension EventLoopFuture where Value: Order {
    func convertToPublic() -> EventLoopFuture<Order.CheckId> {
        return self.map { order in
            return order.convertToPublic()
        }
    }
}