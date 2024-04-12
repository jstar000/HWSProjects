//
//  ExpenseList.swift
//  iExpense
//
//  Created by 임지성 on 3/8/24.
//

import SwiftUI
import SwiftData

struct ExpenseList: View {
    @Query private var expenses: [ExpenseItem]
    @Environment(\.modelContext) var modelContext
    let localCurrency = Locale.current.currency?.identifier ?? "USD"
    
    init(type: String = "All", sortOrder: [SortDescriptor<ExpenseItem>]) {
        _expenses = Query(filter: #Predicate { item in
            if type == "All" {
                return true
                //이런 경우 expenses에 모든 item인스턴스를 넘김
            } else {
                return item.type == type
                //여기서 item in 코드를 없애고 $0.type == type이라고 해도 됨
                //이 경우 item.type이 "Personal"이거나 "Business"인 item인스턴스만 넘김
            }
            
            //-> return이 @Query변수, 즉 expenses에 인스턴스를 return한다는 것으로 이해하면 됨!
        }, sort: sortOrder)
    }
    
    var body: some View {
        List {
            ForEach(expenses) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.type)
                    }
                    
                    Spacer()
                    
                    Text(item.amount, format: .currency(code: localCurrency))
                        .style(for: item)
                }
            }
            .onDelete(perform: removeItems)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        for offset in offsets {
            let item = expenses[offset]
            modelContext.delete(item)
        }
    }
}

#Preview {
    ExpenseList(sortOrder: [SortDescriptor(\ExpenseItem.amount)])
        .modelContainer(for: ExpenseItem.self)
    //Query private var expenses가 ExpenseItem타입을 필요로 해서 여기
    //modelContainer(for: ExpenseItem.self)를 넣는 건가..?
}
