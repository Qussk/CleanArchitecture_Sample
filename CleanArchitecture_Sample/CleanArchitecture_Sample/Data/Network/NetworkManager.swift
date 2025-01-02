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
    
    func fetchData<T: Decodable>(url: String, method: HTTPMethod, paramerers: Parameters?) async -> Result<T, NetworkError> {
        guard let url = URL(string: url) else { return .failure(.urlError) }
        
        let result = await session.request(url, method: method, paramerers: paramerers, headers: tokenHeader).serializingData().response
        if let error = result.error { return .failure(.requestFailed(error.localizedDescription)) }
        guard let data = result.data else { return .failure(.dataNil) }
        guard let response = result.response else { return .failure(.invalid)}
    
        if 200..<400 ~= response.statusCode {
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
