//
//  UserSession.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/21/24.
//

import Foundation
import Alamofire

//네트워크 호출 테스트코드 MockSession 추상화

public protocol SessionProtocol {
    func request(_ convertible: URLConvertible, method: HTTPMethod, paramerers: Parameters, headers: HTTPHeaders) -> DataRequest
    
}

class UserSession: SessionProtocol {
    private var session: Session
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = Session(configuration: config)
    }
    
    func request(
        _ convertible: URLConvertible,
        method: HTTPMethod,
        paramerers: Parameters,
        headers: HTTPHeaders
    ) -> DataRequest {
        return session.request(convertible, method: method, parameters: paramerers, headers:headers)
    }

}
