//
//  Location.swift
//  BucketList
//
//  Created by 임지성 on 6/19/24.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D { 
        // ContentView에서 더 간편하게 나타내기 위해 선언
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    #if DEBUG // 앱 스토어에 release할 때 이 코드는 빠짐
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Lit by over 40,000 lightbulbs.", latitude: 51.501, longitude: -0.141)
    #endif
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        // custom == function을 선언하지 않으면 두 인스턴스를 비교할 때 모든 프로퍼티를 하나씩 대조함
        // Location 인스턴스는 unique identifier가 있으므로 id만 비교하면 됨
        return lhs.id == rhs.id
    }
}
