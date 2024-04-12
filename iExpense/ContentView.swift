//
//  ContentView.swift
//  iExpense
//
//  Created by 임지성 on 2/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false //sheet용
    
    var body: some View {
        NavigationStack {
            List {
                ExpenseSection(title: "Business", expenses: expenses.businessItems, deleteItems: removeBusinessItems)
                ExpenseSection(title: "Personal", expenses: expenses.personalItems, deleteItems: removePersonalItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink {
                    AddView(expenses: expenses)
                } label: {
                    Label("Add Expense", systemImage: "plus")
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet, in inputArray: [ExpenseItem]) {
        //offsets: 삭제할 element의 위치
        //inputArray: personal과 business배열 중 무슨 배열인지
        var objectsToDelete = IndexSet()
        
        //onDelete()가 있어서 리스트를 스와이프하면 delete버튼이 생김. 그 List의 element의 offset을 받아서 여기서 remove()를 통해 지우는 건데, 스와이프를 동시에 여러 개 할 수는 없으니까 element값은 하나만 오잖아
        //그럼 offset값이 하나만 있다는 건데, 왜 for문을 사용하는 건지는 모르겠음
        //어쨌든 리스트에서 원하는 값을 일일이 찾을 때는 이런 방법을 사용하는 듯
        for offset in offsets {
            let item = inputArray[offset]
            
            if let index = expenses.items.firstIndex(of: item) {
                objectsToDelete.insert(index)
            }
        }
        
        expenses.items.remove(atOffsets: objectsToDelete)
    }
    
    func removePersonalItems(at offsets: IndexSet) {
        //굳이 removeItems를 removePersonalItems라는 새로운 사용자 선언 함수로 감싸는 이유는 onDelete()에서 바로 사용할 수 있는 형태(파라미터가 하나만 있어야 하는 듯)로 만들기 위해서임
        removeItems(at: offsets, in: expenses.personalItems)
    }
    
    func removeBusinessItems(at offsets: IndexSet) {
        removeItems(at: offsets, in: expenses.businessItems)
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
}
