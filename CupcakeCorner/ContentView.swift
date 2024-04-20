//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by 임지성 on 4/16/24.
//


import SwiftUI

struct ContentView: View {
    @State private var order = Order()
    //order는 딱 여기서만 생성되고, 이후에는 스크린에서 스크린으로 넘어가며 각 스크린이 같은 데이터를 공유하게 됨
    //Order클래스 내의 프로퍼티는 @State가 아니라 그냥 var로 선언함
    //@Observable을 따르는 클래스 내의 프로퍼티는 굳이 @State로 선언할 필요가 없고,
    //클래스 인스턴스를 만들 때 그 인스턴스만 @State로 선언하면 클래스 내의 프로퍼티 값이 바뀔 때 변화를 감지할 수 있는 듯
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        //picker의 선택지에서 값을 선택하면 그 값이 order.type에 저장됨
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    /// indices는 Swift의 Collection type(배열, 리스트 등)의 모든 인덱스를 나타내는 범위를 반환하는 프로퍼티
                    /// 예를 들어 여기서 Order.types는 ["Vanillla", ..., "Rainboww"]라는 문자열 배열을 나타내므로 indices는 0부터 3까지, 즉 0..<4라는 범위를 반환함
                    /// 따라서 밑에 Order.types[$0]에서 $0은 그냥 0, 1, 2, 3이라는 index임
                    /// indices는 mutable array에서는 배열이 언제든 바뀔 수 있기 때문에 좋지 않지만 여기서처럼 바뀌지 않는 배열에 사용하기에는 좋음
                    
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled)
                    
                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink("Delivery details") {
                        AddressView(order: order)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview {
    ContentView()
}
