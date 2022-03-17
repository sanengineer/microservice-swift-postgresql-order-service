import Vapor
import Fluent

struct OrderController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userAuthByUserIdMiddleware = UserAuthMiddlewareByUserId()
        let userAuthMiddleware = UserAuthMiddleware()
        let midUserAuthUserMiddleware = MidUserAuthMiddleware()
        
        let orderRoutes = routes.grouped("order")
        let orderUserAuthRoutes = orderRoutes.grouped(userAuthMiddleware)
        let orderUserAuthByUserIdRoutes = orderRoutes.grouped(userAuthByUserIdMiddleware)
        let orderMidUserAuthRoutes = orderRoutes.grouped(midUserAuthUserMiddleware)

        routes.grouped(userAuthMiddleware).get(use: getLanding)
        orderMidUserAuthRoutes.get(use: getAllHandler)

        // orderAuthUserRoutes.get(use: getLanding)
        orderUserAuthRoutes.post(use: createHandler)
        orderUserAuthByUserIdRoutes.get(":user_id", use: getOneHandlerByUserId)
        orderUserAuthByUserIdRoutes.get(":user_id", ":order_id", use: getOneHandlerByOrderId)
        orderUserAuthByUserIdRoutes.put(":user_id", ":order_id", use: updateOneHandler)
        orderUserAuthByUserIdRoutes.delete(":order_id",use: deleteOneHandlerByOrderId)
    }

    func getLanding(_ req: Request) throws -> EventLoopFuture<OrderLanding> {
        let landing = OrderLanding(title:"Topping Api Microservices")
        return req.eventLoop.future(landing)
    }

    func createHandler(_ req: Request) throws -> EventLoopFuture<Order> {
        let order = try req.content.decode(Order.self)
        return order.save(on: req.db).map { order }
    }

    func getAllHandler(_ req: Request) throws -> EventLoopFuture<[Order]> {
        return Order.query(on: req.db).all()
    }

    func getOneHandlerByUserId(_ req: Request) throws -> EventLoopFuture<[Order]> { 
        guard let params = req.parameters.get("user_id", as: UUID.self)  else {
            throw Abort(.badRequest)
        }

        return Order.query(on: req.db).filter(\.$user_id == params).all()
    }

    func getOneHandlerByOrderId(_ req: Request) throws -> EventLoopFuture<Order> { 
        return Order.find(req.parameters.get("order_id") ,on: req.db).unwrap(or: Abort(.notFound))
    }

    func updateOneHandler(_ req: Request) throws -> EventLoopFuture<Order> {
        let order = try req.content.decode(Order.self)
        return order.update(on: req.db).map { order }
    }

    func deleteOneHandlerByOrderId(_ req: Request) throws -> EventLoopFuture<Response> { 
        guard let params = req.parameters.get("order_id", as: UUID.self)  else {
            throw Abort(.badRequest)
        }

        return Order.query(on: req.db).filter(\.$id == params).delete().flatMap {
            return req.eventLoop.makeSucceededFuture(Response(status: .accepted, body: "Order deleted"))
        }
    }

}