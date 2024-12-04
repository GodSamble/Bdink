//
//  BaseResponse.swift
//  Buttwink
//
//  Created by 고영민 on 12/4/24.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: T?
}
/// data가 없는 API 통신에서 사용할 BlankData 구조체
struct BlankData: Codable {
}
