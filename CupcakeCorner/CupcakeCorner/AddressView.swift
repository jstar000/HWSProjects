//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by 임지성 on 4/19/24.
//

import SwiftUI

//UserDefaults에 값 저장하기
//주소 didSet으로 저장하고 앱 실행될 때 불러오면 되는 거 아님?

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            
            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}
