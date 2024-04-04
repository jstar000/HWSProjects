//
//  Mission.swift
//  Moonshot
//
//  Created by 임지성 on 3/22/24.
//

import Foundation

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    /// struct 내의 struct를 nested struct라고 함
    /// 코드의 유지보수 측면에서 굉장히 효과적인데, CrewRole이라는 struct를 호출할 때 Mission.CrewRole 이렇게 호출하므로
    /// 만약 몇 백개의 custom struct가 있다고 했을 때 이게 어떤 역할인지 좀 더 직관적으로 이해할 수 있음
    
    let id: Int
    let launchDate: Date?
        //launchDate가 있는 미션도 있고 없는 미션도 있으므로 optional로 선언
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo \(id)"
    }

    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
}
