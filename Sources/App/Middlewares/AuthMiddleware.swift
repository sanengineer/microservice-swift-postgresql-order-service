import Vapor
import Fluent
import FluentPostgresDriver

final class UserAuthMiddleware: Middleware {
  
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let authUrl = Environment.get("AUTH_URL") else {
            return request.eventLoop.future(error: Abort(.internalServerError))
        }
        guard let token = request.headers.bearerAuthorization else {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
        
        //debug
        // print("\n", "TOKEN", token, "\n")
        
         return request
            .client
            .post("\(authUrl)/user/auth/authenticate", beforeSend: {
                authRequest in
                
                //debug
                // print("\nAUTH_REQUEST: ", try authRequest.content.encode(AuthenticateData(token:token.token), as: .json))
                // print("\nAUTH_DATA: ", try authRequest.content.encode(AuthenticateData(token:token.token)), "\n")
                
                try authRequest.content.encode(AuthenticateData(token:token.token), as: .json)
            })
        
            .flatMapThrowing { response in
                let role_id = try response.content.decode(User.self).role_id
                
                if role_id == 1 || role_id == 2 || role_id == 3 {
                guard response.status == .ok  else {
                    if response.status == .unauthorized {
                        throw Abort(.unauthorized, reason: "UNAUTHORIZED")
                    } else {
                        throw Abort(.internalServerError)
                    }
                }
                } else {
                    throw Abort(.unauthorized)
                }

                //debug
                //    print("\n","RESPONSE:\n", response,"\n")
                //    print("\n", "TRYYY\n", try response.content.decode(Auth.self), "\n")
                //    print("\n","ROLE_ID:", role_id,"\n")
            }
        
            .flatMap {
                return next.respond(to: request)
            }
    }
}

final class UserAuthMiddlewareByUserId: Middleware {
  
    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        guard let authUrl = Environment.get("AUTH_URL") else {
            return request.eventLoop.future(error: Abort(.internalServerError))
        }
        guard let token = request.headers.bearerAuthorization else {
            return request.eventLoop.future(error: Abort(.unauthorized))
        }
        
        //debug
        // print("\n", "TOKEN", token, "\n")
        
         return request
            .client
            .post("\(authUrl)/user/auth/authenticate", beforeSend: {
                authRequest in
                
                //debug
                // print("\nAUTH_REQUEST: ", try authRequest.content.encode(AuthenticateData(token:token.token), as: .json))
                // print("\nAUTH_DATA: ", try authRequest.content.encode(AuthenticateData(token:token.token)), "\n")
                
                try authRequest.content.encode(AuthenticateData(token:token.token), as: .json)
            })
        
            .flatMapThrowing { response in
                let role_id = try response.content.decode(User.self).role_id 

                let user = try response.content.decode(User.self)
                
                let test_user =  Order.find(user.id, on: request.db)


                
                // if role_id == 1 || role_id == 2 || role_id == 3 {
                //     guard response.status == .ok  else {
                //         if response.status == .unauthorized {
                //             throw Abort(.unauthorized, reason: "UNAUTHORIZED")
                //         } else {
                //             throw Abort(.internalServerError)
                //         }
                //     }  
                // } else {
                //     throw Abort(.unauthorized)
                // }

                //debug
                //    print("\n","RESPONSE:\n", response,"\n")
                //    print("\n", "TRYYY\n", try response.content.decode(Auth.self), "\n")
                   print("\n","ROLE_ID:", role_id,"\n")
                   print("TESTT: \(test_user)")
            }
            .flatMap {
               return next.respond(to: request)
            }
    }
}
