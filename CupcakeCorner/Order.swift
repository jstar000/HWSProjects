//
//  Order.swift
//  CupcakeCorner
//
//  Created by 임지성 on 4/19/24.
//

import Foundation
import SwiftUI

@Observable
class Order: Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    enum CodingKeys: String, CodingKey {
        //@Observable macro에 의해 네트워크에 데이터 request 시 이상한 언더바가 생기는 문제가 발생함
        //그 문제를 해결하기 위해 CodingKeys를 사용해야 함
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
    
    init() {
        if let savedName = UserDefaults.standard.data(forKey: "Name") {
            if let decodedName = try? JSONDecoder().decode(String.self, from: savedName) {
                name = decodedName
                return
            }
        }
    }
    
    //ContentView
    var type = 0
    var quantity = 3
    var specialRequestEnabled = false {
        didSet {
            /// specialRequestEnabled가 true인 상태에서 extraFrosting과 addSprinkles값을 바꾸고,
            /// 다시 specialRequestEnabled를 false로 바꾸면 그 바꾼 값이 그대로 저장되어 있음
            /// 이걸 방지하기 위해 didSet을 통해 specialRequestEnabled가 true에서 false가 된 경우
            /// extraFrosting과 addSprinkles도 무조건 false로 바꾸는 코드를 추가함
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    //AddressView
    var name = "" {
        didSet {
            if let encoded = try? JSONEncoder().encode(name) {
                UserDefaults.standard.set(encoded, forKey: "Name")
            }
        }
    }
    var streetAddress = "" {
        didSet {
            UserDefaults.standard.set(streetAddress, forKey: "StreetAddress")
        }
    }
    var city = "" {
        didSet {
            UserDefaults.standard.set(city, forKey: "City")
        }
    }
    var zip = "" {
        didSet {
            UserDefaults.standard.set(zip, forKey: "Zip")
        }
    }
    
    var hasValidAddress: Bool {
        if name.checkValidity() || streetAddress.checkValidity() || city.checkValidity() || zip.checkValidity() {
            return false
        }
        
        return true
    }
    
    //CheckoutView
    var cost: Double {
        // 케익 하나 당 $2
        var cost = Double(quantity) * 2
        
        // complicated cakes cost more
        cost += (Double(type) / 2)
        
        // extra frosting $1
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // sprinkles $0.5
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
}

extension String {
    func checkValidity() -> Bool {
        self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }
}
