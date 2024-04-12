//
//  AddView.swift
//  iExpense
//
//  Created by 임지성 on 2/27/24.
//

import SwiftUI

struct AddView: View {
    @State private var name = "New Expense"
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    @Environment(\.dismiss) var dismiss
    
    let localCurrency = Locale.current.currency?.identifier ?? "USD"
    
    let types = ["Business", "Personal"]
    
    var expenses: Expenses
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: localCurrency))
                    .keyboardType(.decimalPad)
                //문자열은 text: $__, 숫자는 value: $__
            }
            .navigationTitle($name)
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = ExpenseItem(name: name, type: type, amount: amount)
                        expenses.items.append(item)
                        dismiss()
                        //-> dismiss()에서 @Environment로 선언된 dismiss 구조체를 함수처럼 사용하는 형태를 볼 수 있는데,
                        //이는 dismiss 구조체 내에 callAsFunction이 구현되어있기 때문임
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
    //expense는 ContentView로부터 넘겨받는 데이터인데, preview에는 그냥 dummy data를 주면 됨
}
