//
//  ContentView.swift
//  iExpense
//
//  Created by 임지성 on 2/23/24.
//

import SwiftUI

struct ExpenseItem: Identifiable {
    //Identifiable 프로토콜을 따른다면 무조건 id가 있어야 함
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]()
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    //items가 Identifiable 프로토콜을 따르므로 id가 무조건 있다는게 보장됨
                    //-> 따로 id: \.id 이런 거 할 필요 없음
                    Text(item.name)
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                    expenses.items.append(expense)
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
}

#Preview {
    ContentView()
}
