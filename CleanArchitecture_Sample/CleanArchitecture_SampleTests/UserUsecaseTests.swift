//
//  UserUsecaseTests.swift
//  CleanArchitecture_SampleTests
//
//  Created by 변윤나 on 12/22/24.
//

import XCTest
@testable import CleanArchitecture_Sample

//프로토콜을 활용하면 테스트코드 작성하기 쉽다! 추상화된 객체를 의존하도록 만들었기 떄문에 쉽게 테스트코드를 작성할 수 있는 환경이 되었다.
final class UserUsecaseTests: XCTestCase {

    var usecase: UserListUsecaseProtocol!
    var repository: UserRepositoryProtocol!
    
    override func setUp() {
        super.setUp()
        repository = MockUserRepository()
        usecase = UserListUsecase(repository: repository)
    }
        
    func testCheckFavoritState() {
        let favoriteUsers = [
            UserListItem(id: 1, login: "user1", imageURL: ""),
            UserListItem(id: 2, login: "user2", imageURL: "")
        ]
        
        let fetchUsers = [
            UserListItem(id: 1, login: "user1", imageURL: ""),
            UserListItem(id: 3, login: "user3", imageURL: "")
        ]
        
        let result = usecase.checkFavoritsState(fetchUsers: fetchUsers, favoritUsers: favoriteUsers)
        XCTAssertEqual(result[0].isFavorit, true)
        XCTAssertEqual(result[1].isFavorit, false)
    }
    
    func testConvertListToDictionary() {
        let users = [
            UserListItem(id: 1, login: "Caron", imageURL: ""),
            UserListItem(id: 2, login: "Bob", imageURL: ""),
            UserListItem(id: 3, login: "Qussk", imageURL: ""),
            UserListItem(id: 4, login: "Catfi", imageURL: ""),
        ]
        
        let result = usecase.covertListToDictionary(favoritUsers: users)
        XCTAssertEqual(result.keys.count, 3)
        XCTAssertEqual(result["A"]?.count, nil)
        XCTAssertEqual(result["B"]?.count, 1)
        XCTAssertEqual(result["C"]?.count, 2)
    }
    
    override func tearDown() {
        repository = nil
        usecase = nil
        super.tearDown()
    }
}
