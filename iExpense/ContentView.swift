//
//  ContentView.swift
//  iExpense
//
//  Created by 임지성 on 2/23/24.
//

import SwiftUI

struct ExpenseItem: Identifiable {
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
    @State private var showingAddExpense = false //sheet용
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                //.sheet()을 List에 붙이든 NavigationStack에 붙이든 관계 없다고 함
                
                AddView(expenses: expenses)
                //contentView에 이미 expenses라는 인스턴스를 만들어 놨고 AddView에서 원하는 item을 add한 뒤 expenses인스턴스에 넣을 것임
                //따라서 AddView에 새로운 expenses인스턴스를 넣지 말고 그냥 여기 있는 expenses를 AddView뷰에 인자 형태로 넘겨주면 됨
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
