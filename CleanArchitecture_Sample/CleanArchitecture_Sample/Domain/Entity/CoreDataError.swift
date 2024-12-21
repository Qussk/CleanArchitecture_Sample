//
//  CoreDataError.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/18/24.
//

import Foundation


public enum CoreDataError: Error {
    case entitiyNotFound(String)
    case saveError(String)
    case readError(String)
    case deleteError(String)

    public var description:String {
        switch self {
        case .entitiyNotFound(let objectName):
            return "객체를 찾을 수 없습니다. \(objectName)"
        case .saveError(let message):
            return "객체 저장 에러 \(message)"
        case .readError(let message):
            return "객체 조회 에러 \(message)"
        case .deleteError(let message):
            return "객체 삭제 에러 \(message)"
        }
    }
}
