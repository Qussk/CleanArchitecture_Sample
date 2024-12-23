//
//  NetworkManager.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/21/24.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, paramerers: Parameters?) async -> Result<T, NetworkError>
}

public class NetworkManager: NetworkManagerProtocol {
    private let session: SessionProtocol
    init(session: SessionProtocol) {
        self.session = session
    }
    

    private let tokenHeader: HTTPHeaders = {
        let tokenHeader = HTTPHeader(name: "Authorization", value: "Bearer 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")
        return HTTPHeaders([tokenHeader])
    }()
    
//    var httpHeaders: [String: String] {
//        var headers: [String: String] = [:]
//        let accessToken = "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"
//        headers["Authorization"] = "Bearer \(accessToken)"
//        return headers
//    }

    
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, paramerers: Parameters?) async -> Result<T, NetworkError> {
        guard let url = URL(string: url) else { return .failure(.urlError) }
        
        let result = await session.request(url, method: method, paramerers: paramerers!, headers: tokenHeader).serializingData().response
        if let error = result.error { return .failure(.requestFailed(error.localizedDescription)) }
        guard let data = result.data else { return .failure(.dataNil) }
        guard let response = result.response else { return .failure(.invalid)}
        if 200 ..< 300 ~= response.statusCode {
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                return .success(data)
            } catch {
                return .failure(.failToDecode(error.localizedDescription))
            }
        }
        else {
            return .failure(.serverError(response.statusCode))
        }
    }
}


//User Store Menu Pay결과등. 하나로 처리.
