//
//  MockUserRepository.swift
//  CleanArchitecture_SampleTests
//
//  Created by 변윤나 on 12/22/24.
//

import Foundation
@testable import CleanArchitecture_Sample

//지정해준 값으로 테스트, 검증을 할거기 떄문.
public struct MockUserRepository: UserRepositoryProtocol {
    public func fetchUser(query: String, page: Int) async -> Result<CleanArchitecture_Sample.UserListResult, CleanArchitecture_Sample.NetworkError> {
        return .failure(.dataNil)
    }
    
    public func getFavoritUsers() -> Result<[CleanArchitecture_Sample.UserListItem], CleanArchitecture_Sample.CoreDataError> {
        return .failure(.entitiyNotFound(""))
    }
    
    public func saveFavoriteUser(user: CleanArchitecture_Sample.UserListItem) -> Result<Bool, CleanArchitecture_Sample.CoreDataError> {
        return .failure(.entitiyNotFound(""))
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CleanArchitecture_Sample.CoreDataError> {
        return .failure(.entitiyNotFound(""))
    }
    
    
}
