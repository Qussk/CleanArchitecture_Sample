//
//  UserNetwork.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/21/24.
//

import Foundation

public protocol UserNetworkProtocol {
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError>
}

final public class UserNetwork: UserNetworkProtocol {
    private let manager: NetworkManagerProtocol
    init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        let url = "https://api.github.com/search/users?q=\(query)&pages\(page)"
        return await manager.fetchData(url: url, method: .get, paramerers: nil)
    }
}
