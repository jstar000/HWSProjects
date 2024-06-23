//
//  EditUserView.swift
//  SwiftDataProject
//
//  Created by 임지성 on 5/15/24.
//

import SwiftUI
import SwiftData

struct EditUserView: View {
    @Bindable var user: User
    //ContentView에서 EditUserView로 @Model object를 넘겨줌 
    //-> 받는 뷰에서는 @Bindable로 객체 생성
    
    var body: some View {
        Form {
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("Join Date", selection: $user.joinDate)
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    //custom configuration과 container를 만들어줘야 함
    //자세한 내용은 Project 11 참고(방식 완전히 똑같음)
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)
        let user = User(name: "Taylor Swift", city: "Nashville", joinDate: .now)
        return EditUserView(user: user)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
