//
//  UserView.swift
//  SwiftDataProject
//
//  Created by 임지성 on 5/17/24.
//

import SwiftData
import SwiftUI

struct UserView: View {
    @Query var users: [User]
    /// 이걸 @State같은게 아닌 @Query로 선언하네? Query데이터를 ContentView에서 받을 거니까 그런 듯
    /// @Query var users: [User]로 선언하고 predicate나 sort order같은건 다른 방법으로 추가할 거임
    /// ContentView에서 데이터를 pass받을 건데, 가장 좋은 방법은 view에 initializer를 통해 value를 넘기고 그걸
    /// query를 create하는 데 사용하는 거라고 함
    /// 우리 목표는 모든 사용자를 보여주거나, joinDate가 현재보다 future인 사용자만 보여주도록 하는 것임
    /// 따라서 ContentView에서 UserView에 데이터를 넘겨줄 때 User인스턴스의 joinDate값만 확인할 수 있으면 되는데,
    /// 따라서 굳이 User인스턴스 전체를 넘겨줄 필요 없이, UserView에 이니셜라이저를 만들어서 딱 joinDate만 
    /// 받아올 수 있도록 만들면 됨!
    /// 여기서 @Query var users: [User] 이렇게 users를 선언할 때 Query문의 조건(filter, sort기준)을
    /// 미리 선언해두지 않고 아래 initializer구문에서 Query문의 조건을 추가하는 이유가 나옴
    /// joinDate만 받아오기 위해 initializer를 따로 선언하긴 했는데, 그 값을 결국 Query문에 넣을 수 있어야
    /// 우리가 원하는 대로 전체 users배열에서 joinDate가 특정 날짜인 사람들만 'filter'할 수 있음
    /// Query문을 초기화하는 방법은 이때까지 했던 것처럼 그냥 선언과 동시에 하는 방법과, 아래 initializer구문에서
    /// 한 것처럼 인스턴스(UserView struct) 생성 시점에 초기화시키는 방법 두 가지가 있음
    /// 이때까지는 따로 값을 받아오는 경우 없이 그냥 하나의 뷰 안에서 쿼리문을 실행했기 때문에 굳이 쿼리문을
    /// 인스턴스 생성 시점에 만들 필요가 없었지만, 여기서는 ContentView로부터 joinDate값을 받아오고, 그 값을
    /// 기준으로 Query문을 생성해 쿼리 데이터를 불러올 것이기때문에 initializer에서 쿼리문을 동적으로 생성하는 것임
    
    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User> { user in
            user.joinDate >= minimumJoinDate
        }, sort: sortOrder)
        
        /// users앞에 붇은 _ 는 뭘까?
        /// 위 설명 보면 이 initializer는 쿼리문을 생성하는 두 가지 방법(일반적인 방법처럼 생성과 동시에 초기화하는 방법,
        /// 이렇게 인스턴스 생성과 동시에 동적으로 생성하는 방법) 중 쿼리문을 동적(?)으로 생성하는 방법임
        /// 그러니까 쿼리 자체를 우리가 원하는 대로 바꿔야한다는 뜻인데, 그렇다면 쿼리에 접근을 어떻게 하냐??
        /// 변수의 이름 바로 앞에 붙은 _ 는 property wrapper 그 자체에 접근하겠다는 뜻임
        /// 따라서 _users 는 users의 property wrapper, 즉 @Query에 접근하겠다는 뜻!!
        /// ==> Query문이 minimumJoinDate라는, ContentView에서 넘겨받는 값을 기준으로
        /// 쿼리할 수 있도록 initializer에서 동적으로 생성함!
    }
    
    var body: some View {
        List(users) { user in
            Text(user.name)
        }
    }
}

#Preview {
    UserView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
    /// Bookworm의 DetailView나 이 프로젝트의 EditUserView보면 Preview에 이런저런 코드가 되게 많은데,
    /// 그건 @Model object를 @Bindable로 받기때문에(@Model은 @Observable과 같은 observation을 사용하므로
    /// @Observable 인스턴스와 마찬가지로 @Bindable로 객체를 받을 수 있음) 그런 코드가 필요했던 거고,
    /// 여기서처럼 @Query 변수, 즉 SwiftData의 데이터를 @Query로 가져오는 경우라면 그냥 modelContainer만
    /// 추가해주면 되는 듯..?
}
