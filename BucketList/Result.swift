//
//  Result.swift
//  BucketList
//
//  Created by 임지성 on 6/23/24.
//

import Foundation

// 위키피디아에서 장소 데이터 다운로드 받기 위해 선언

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
}
