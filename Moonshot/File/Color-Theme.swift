//
//  Color-Theme.swift
//  Moonshot
//
//  Created by 임지성 on 3/23/24.
//

import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
    /// ShapeStyle의 extension 내에 darkBkgd와 lightBkgd라는 두 색깔을 추가함으로써
    /// SwiftUI 중 ShapeStyle을 따르는 어떤 거라고 이 색깔들을 사용할 수 있도록 만듦
    
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }
    
    static var lightBackground: Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
}
