//
//  Order.swift
//  CupcakeCorner
//
//  Created by 임지성 on 4/19/24.
//

import Foundation

@Observable
class Order {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
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
}
