//
//  ContentView.swift
//  iExpense
//
//  Created by 임지성 on 2/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var expenseType = "All"
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.amount),
        SortDescriptor(\ExpenseItem.name)
    ]
    
    var body: some View {
        NavigationStack {
            ExpenseList(type: expenseType, sortOrder: sortOrder)
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink {
                    AddView()
                } label: {
                    Label("Add Expense", systemImage: "plus")
                }
                
                Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                    Picker("Filter", selection: $expenseType) {
                        Text("Show All Expenses")
                            .tag("All")
                        
                        Divider()
                        //Menu 안에 divider를 넣으면 iOS가 알아서 잘 분리시켜줌
                        
                        ForEach(AddView.types, id: \.self) { type in
                            Text(type)
                                .tag(type)
                        }
                    }
                }
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort By", selection: $sortOrder) {
                        Text("Name (A-Z)")
                            .tag([
                                SortDescriptor(\ExpenseItem.name),
                                SortDescriptor(\ExpenseItem.amount)
                            ])
                        
                        Text("Name (Z-A)")
                            .tag([
                                SortDescriptor(\ExpenseItem.name, order: .reverse),
                                SortDescriptor(\ExpenseItem.amount)
                            ])
                        
                        Text("Amount (Cheapest First)")
                            .tag([
                                SortDescriptor(\ExpenseItem.amount),
                                SortDescriptor(\ExpenseItem.name)
                            ])
                        
                        Text("Amount (Most Expensive First)")
                            .tag([
                                SortDescriptor(\ExpenseItem.amount, order: .reverse),
                                SortDescriptor(\ExpenseItem.name)
                            ])
                    }
                }
            }
        }
    }
}

extension View {
    func style(for item: ExpenseItem) -> some View {
        if item.amount < 100 {
            return self.font(.body)
        } else if item.amount < 1000 {
            return self.font(.title3)
        } else {
            return self.font(.title)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseItem.self)
}
