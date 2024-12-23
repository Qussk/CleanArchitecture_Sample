//
//  UserListViewModel.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/22/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserListViewModelProtocol {
}

public final class UserListViewModel: UserListViewModelProtocol {
    private let usecase: UserListUsecaseProtocol
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: []) //fetchUser 즐겨찾기 여부를 위한 전체목록
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: []) //목록에 보여줄 리스트
    private var page: Int = 1
    
    public init(usecase: UserListUsecaseProtocol) {
        self.usecase = usecase
    }
    
    //VM에게 전달 되어야할 이벤트
    public struct Input {
        //탭, 텍스트필드, 즐겨찾기 추가 or 삭제, 페이지네이션 Observable
        let tabButtonType: Observable<TabButtonType>
        let query: Observable<String>
        let saveFavorite: Observable<UserListItem>
        let deleteFavorite: Observable<Int>
        let fetchMore: Observable<Void>
    }
    
    //VM에게 전달할 뷰의 데이터
    public struct Output {
        let callData: Observable<[UserListCellData]>
        let error: Observable<String>
    }
    
    public func trenform(input: Input) -> Output {
        
        input.query.bind { [weak self] query in
            //userFetch and getFavoriteUsers.
            guard let self = self, validateQuery(query: query) else {
                self?.getFavoriteUsers(query: "")
                return
            }
            page = 1
            fetchUser(query: query, page: page)
            getFavoriteUsers(query: query)
        }.disposed(by: disposeBag)
        
        
        input.saveFavorite
            .withLatestFrom(input.query, resultSelector: { user, query in //query값을 받아오기 위해 (input.query)옵져버블 활용
                return (user, query) //튜플 형태로 리턴됨.
            })
            .bind { [weak self] user, query in
                self?.saveFavoriteUser(user: user, query: query)
        }.disposed(by: disposeBag)
        

        input.deleteFavorite
            .withLatestFrom(input.query, resultSelector: { ($0, $1) }) //튜플이라서 이런 식으로 줄일수있음.
            .bind { [weak self] userId, query in
                self?.deleteFavoriteUser(userID: userId, query: query)
        }.disposed(by: disposeBag)
        

        input.fetchMore
            .withLatestFrom(input.query)
            .bind { [weak self] query in
                guard let self = self else { return }
                page += 1
                fetchUser(query: query, page: page)
        }.disposed(by: disposeBag)
        
        
        
        //탭 -> api 유저 or 즐겨찾기 유지
        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(input.tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList)
            .map { [weak self] tabType, fetch, favorite, all in
            var cellData: [UserListCellData] = []
            guard let self = self else { return cellData }
            
            //Tab에 따라 fetchUserList or favoriteUserList
            switch tabType {
            case .api :
                let tuple = usecase.checkFavoritsState(fetchUsers: fetch, favoritUsers: all)
                let userCellList = tuple.map { user, isFavorite in
                    UserListCellData.user(user: user, isFavorite: isFavorite)
                }
                return userCellList
            case .favorite:
                let dict = usecase.convertListToDictionary(favoritUsers: favorite)
                let keys = dict.keys.sorted()
                keys.forEach { key in
                    if let users = dict[key] {
                        cellData += users.map { UserListCellData.user(user: $0, isFavorite: true) }
                    }
                }
            }
            return cellData
        }
        
        return Output(callData: cellData, error: error.asObservable())
    }
    
    //유저 통신 fetchData
    private func fetchUser(query: String, page: Int) {
        guard let urlAllowedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return } //인코딩
        Task {
            let result = await usecase.fetchUser(query: urlAllowedQuery, page: page)
            switch result {
            case .success(let users):
                return page == 0 ? fetchUserList.accept(users.items) : fetchUserList.accept(fetchUserList.value + users.items)
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }
    //즐겨찾기 유저 조회
    private func getFavoriteUsers(query: String) {
        let result = usecase.getFavoritUsers()
        switch result {
        case .success(let users):
            if query.isEmpty {
                favoriteUserList.accept(users)
            }
            else {
                let filteredUsers = users.filter { user in
                    user.login.contains(query)
                }
                favoriteUserList.accept(filteredUsers)
            }
            allFavoriteUserList.accept(users)
        case .failure(let error):
            self.error.accept(error.description)
        }
        
    }
    
    //query가 유효하지않는 값이 있을때
    private func validateQuery(query: String) -> Bool {
        return query.isEmpty ? false : true
    }
    
    //즐겨찾기 추가
    private func saveFavoriteUser(user: UserListItem, query: String) {
        let result = usecase.saveFavoriteUser(user: user)
        switch result {
        case .success(let user) :
            getFavoriteUsers(query: query)
        case .failure(let error) :
            self.error.accept(error.description)
        }
    }
    //즐겨찾기 삭제
    private func deleteFavoriteUser(userID: Int, query: String) {
        let result = usecase.deleteFavoriteUser(userID: userID)
        switch result {
        case .success:
            getFavoriteUsers(query: query)
        case .failure(let error):
            self.error.accept(error.description)
        }
        
    }
}


public enum TabButtonType {
    case api
    case favorite
    
    var title: String {
        switch self {
        case .api: return "조회"
        case .favorite: return "즐겨찾기"
        }
    }
}

public enum UserListCellData {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
}
