//
//  ContentView.swift
//  iExpense
//
//  Created by 임지성 on 2/23/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    
    //didSet{ }에서 사용자가 입력한 item을 저장하고, init()에서 어플이 실행될 때 저장된 item들을 load함
    
    var items = [ExpenseItem]() {
        didSet {
            //items배열이 호출될 때마다 didSet 프로퍼티 감시자가 호출됨
            //-> 변경될 때마다 아래 인코딩 코드가 실행되는 것!(computed property는 아님)
            if let encoded = try? JSONEncoder().encode(items) {
                //JSEncoder().encode(something): "인코더를 만들고 something을 인코드하는 데 이걸 사용해"라는 명령을 한 번에 실행하는 코드
                //이때 encode()는 Codable프로토콜을 따르는 것만 인코딩할 수 있음
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            //"Items"키워드로 저장된 데이터를 Data객체로 읽는 코드
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                //위에서 읽은 Data객체인 savedItems를 unarchiving해 ExpenseItem객체 배열 생성
                //[ExpenseItem].self에서 .self의 의미: [ExpenseItem]만 작성한다면 Swift는 이게 무슨 뜻인지 잘 모름 -> 클래스의 copy를 만드려는 건가? static property나 메서드를 reference하려는 건가? 이 클래스의 인스턴스를 만드려는 건가?
                //-> 이 타입 자체를 refer한다는 것(==type object)을 Swift에 알리기 위해 뒤에 .self를 작성함
                //=> .decode([ExpenseItem].self, from: savedItems)는
                //savedItems로부터 [ExpenseItem]배열을 decode하는 코드!
                items = decodedItems
                return
            }
        }
        
        items = []
    }
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
