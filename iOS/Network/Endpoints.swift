//
//  Endpoints.swift
//  BURT (iOS)
//
//  Created by Mathieu Perrais on 2/13/21.
//

import Foundation
import Envol

enum AppleiTunesEndpoint {
    public static let production = ServerEnvironment(host: "itunes.apple.com", pathPrefix: "")
}


private let mainLoader: HTTPLoader! = HTTPLoader.getDefault(serverEnvironment: AppleiTunesEndpoint.production,
                                                            maximumNumberOfRequests: 30,
                                                            session: URLSession.shared)


let iTunesConnection = Connection(loader: mainLoader)












/// !!!!!!!!!!!!!!!!!! -----------------------  REPRENDRE LA
// POURQUOI PAS FAIRE DES SOUS ClASS DE REQUETE POUR SEPARER SI BESOIN?

//extension Request where Response == Review2 {
//    // Let's make that static and public that are exposed to the users and call the super customizable below
//    // many static func can call the same customizable init
//    static func person(_ id: Int) -> Request<Response> {
//        return Request(personID: id)
//    }
//
//    // Let's make that super customizable and Private (with a lot of parameters)
//    init(personID: Int) {
//        let request = HTTPRequest(path: "/api/person/\(personID)/")
//
//        // because Person: Decodable, this will use the initializer that automatically provides a JSONDecoder to interpret the response
//        self.init(underlyingRequest: request)
//    }
//}
