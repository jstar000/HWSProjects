//
//  String-EmptyChecking.swift
//  CupcakeCorner
//
//  Created by 임지성 on 4/21/24.
//

import Foundation

extension String {
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
