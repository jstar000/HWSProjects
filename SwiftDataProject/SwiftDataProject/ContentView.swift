//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by 임지성 on 5/15/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    //@State private var path = [User]()
    
    @State private var showingUpcomingOnly = false
    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate),
    ]
    
    var body: some View {
        NavigationStack { //기억 안나면 Navigation 프로젝트 참고
            UserView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
            //.distantPast는 적어도 2000년 이전의 past를 의미함
            .navigationTitle("Users")
            .toolbar {
                Button(showingUpcomingOnly ? "Show Everyone" : "Show Upcoming") {
                    showingUpcomingOnly.toggle()
                }
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([
                                SortDescriptor(\User.name),
                                SortDescriptor(\User.joinDate),
                            ])
                        
                        Text("Sort by Join Date")
                            .tag([
                                SortDescriptor(\User.joinDate),
                                SortDescriptor(\User.name)
                            ])
                    }
                }
                
                Button("Add Samples", systemImage: "plus") {
                    try? modelContext.delete(model: User.self)
                    //delete(model:): modelContext에서 모든 User타입의 데이터를 지움
                    
                    let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                    let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
                    let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                    let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))
                    
                    modelContext.insert(first)
                    modelContext.insert(second)
                    modelContext.insert(third)
                    modelContext.insert(fourth)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
