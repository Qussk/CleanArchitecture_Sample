//
//  UserCoreData.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/21/24.
//

import Foundation
import CoreData

public protocol UserCoreDataProtocol {
    func getFavoritUsers() -> Result<[UserListItem], CoreDataError> //전체 즐겨찾기 리스트 불러오기
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError>
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError>
}


public struct UserCoreData: UserCoreDataProtocol {
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    public func getFavoritUsers() -> Result<[UserListItem], CoreDataError> {
        let fetchRequest: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        do {
            let result = try viewContext.fetch(fetchRequest)
            let userList: [UserListItem] = result.compactMap { favorUser in
                guard let login = favorUser.login, let imageURL = favorUser.imageURL else { return nil }
                //compactMap의 경우 nil을 지움.(nil이 아닌 데이터만 담음.)
                return UserListItem(id: Int(favorUser.id), login: login, imageURL: imageURL)
            }
            return .success(userList)
        }
        catch {
            return .failure(.readError(error.localizedDescription))
        }
    }
    
    public func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteUser", in: viewContext) else {
            return .failure(.entitiyNotFound("FavoritUSer: Not Found"))
        }
        let userObject = NSManagedObject(entity: entity, insertInto: viewContext)
        userObject.setValue(user.id, forKey: "id")
        userObject.setValue(user.login, forKey: "login")
        userObject.setValue(user.imageURL, forKey: "imageURL")

        do {
            try viewContext.save()
            return .success(true)
        }
        catch {
            return .failure(.saveError(error.localizedDescription))
        }
    }
    
    public func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError> {
        let fetchRequst: NSFetchRequest<FavoriteUser> = FavoriteUser.fetchRequest()
        fetchRequst.predicate = NSPredicate(format: "id == %d", userID)
        
        do {
            let result = try viewContext.fetch(fetchRequst)
            result.forEach { favorUser in
                viewContext.delete(favorUser)
            }
            try viewContext.save()
            return .success(true)
        }
        catch {
            return .failure(.deleteError(error.localizedDescription))
        }
    }
}
