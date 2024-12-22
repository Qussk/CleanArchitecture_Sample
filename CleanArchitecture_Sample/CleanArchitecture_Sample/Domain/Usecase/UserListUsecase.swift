//
//  UserListUsecase.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/18/24.
//

import Foundation


public protocol UserListUsecaseProtocol {
    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> //유저리스트 불러오기 (원격)
    func getFavoritUsers() -> Result<[UserListItem], CoreDataError> //전체 즐겨찾기
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError>
    //유저리스트 - 즐겨찾기 포함된 유저인지.
    func checkFavoritsState(fetchUsers: [UserListItem], favoritUsers: [UserListItem]) -> [(user: UserListItem, isFavorit: Bool)]
    //배열 -> Dic 초성 [초성 : [유저리스트]]
    func covertListToDictionary(favoritUsers: [UserListItem]) -> [String: [UserListItem]]
}

public struct UserListUsecase: UserListUsecaseProtocol {
    private let repository: UserRepositoryProtocol
    
    public init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        return await repository.fetchUser(query: query, page: page)
    }
    
    public func getFavoritUsers() -> Result<[UserListItem], CoreDataError> {
        return repository.getFavoritUsers()
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        return repository.saveFavoriteUser(user: user)
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError> {
        return repository.deleteFavoriteUser(userID: userID)
    }
    
    public func checkFavoritsState(fetchUsers: [UserListItem], favoritUsers: [UserListItem]) -> [(user: UserListItem, isFavorit: Bool)] {
        let favoritSet = Set(favoritUsers)
        return fetchUsers.map { user in
            return favoritSet.contains(user) ? (user: user, isFavorit: true) : (user: user, isFavorit: false)
        }
    }

    public func covertListToDictionary(favoritUsers: [UserListItem]) -> [String : [UserListItem]] {
        return favoritUsers.reduce(into: [String: [UserListItem]]()) { dict, user in //[:]
            if let firstString = user.login.first {
                let key = String(firstString).uppercased()
                dict[key, default: []].append(user)
            }
        }
    }

}
