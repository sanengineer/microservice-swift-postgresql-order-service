import Vapor
import Fluent

struct OrderController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let userAuthMiddlewareByUserId = UserAuthMiddlewareByUserId()
        // let userMiddleware = UserAuthMiddleware()
        
        // let orderRoutes = routes.grouped("order")
        // let orderAuthUserRoutes = orderRoutes.grouped(userMiddleware)

        routes.grouped(userAuthMiddlewareByUserId).get(use: getLanding)
        // orderAuthUserRoutes.get(use: getLanding)
        // orderAuthUserRoutes.post(use: createHandler)
        // orderAuthUserRoutes.get(use: getAllHandler)
        // orderAuthUserRoutes.get(":order_id", use: getOneHandler)
        // orderAuthUserRoutes.put(":order_id", use: updateOneHandler)
        // orderAuthUserRoutes.delete(use: deleteOneHandler)
    }

    func getLanding(_ req: Request) throws -> EventLoopFuture<OrderLanding> {
        let landing = OrderLanding(title:"Topping Api Microservices")
        return req.eventLoop.future(landing)
    }

}