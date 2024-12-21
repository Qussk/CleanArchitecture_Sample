//
//  NetworkError.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/18/24.
//

import Foundation

public enum NetworkError: Error {
    case urlError
    case invalid
    case failToDecode(String)
    case dateNil
    case serverError(Int)
    case requestFailed(String)
    
    public var description: String {
        switch self {
        case .urlError:
            return "USL이 올바르지 않습니다."
        case .invalid:
            return "응답값이 유효하지 않음"
        case .failToDecode(let description):
            return "디코팅 에러 \(description)"
        case .dateNil:
            return "데이터가 없습니다."
        case .serverError(let statusCode):
            return "서버에러 \(statusCode)"
        case .requestFailed(let message):
            return "서버 요청 실패 \(message)"
        }
    }
}
