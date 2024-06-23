//
//  Expense.swift
//  iExpense
//
//  Created by 임지성 on 2/28/24.
//

import Foundation
import SwiftData

@Model
class ExpenseItem {
    let name: String
    let type: String
    let amount: Double
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}
