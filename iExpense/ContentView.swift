//
//  ContentView.swift
//  iExpense
//
//  Created by 임지성 on 2/23/24.
//

import SwiftUI

struct ExpenseItem {
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
    //클래스를 @Observable로 mark했더라도 어쨌든 Swift가 계속 값의 변화를 감시하게 하기 위해서는 @State로 선언해야 함
    
    var body: some View {
        NavigationStack {
            List {
                //굳이 List와 ForEach를 따로 사용하는 이유
                //-> .onDelete() modifier를 사용하기 위해서는 ForEach가 무조건 필요함
                ForEach(expenses.items, id: \ExpenseItem.name) { item in
                    //\.name의 definition 들어가보면 그냥 ExpenseItem구조체의 프로퍼티로 나옴
                    //epenses.items가 ExpenseItem이어서 바로 ExpenseItem의 프로퍼티인 item으로 접근할 수 있는건가?
                    //\.expenses.items.name이나 \.items.name 이렇게는 오류나고 \ExpenseItem.name 이렇게 작성하면 오류발생x
                    Text(item.name)
                }
                .onDelete(perform: removeItems)
                //removeItems(at:)의 파라미터를 명시 안해도 자동으로 row의 index값 넘겨주는 듯
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
