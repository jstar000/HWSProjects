//
//  Astronaut.swift
//  Moonshot
//
//  Created by 임지성 on 3/14/24.
//

import Foundation

struct Astronaut: Codable, Identifiable {
    //Codable: JSON으로부터 바로 struct의 인스턴스를 만들기 위해
    //Identifiable: ForEach에서도 사용하고 다른 데서도 사용한다고 함
    let id: String
    let name: String
    let description: String
}
