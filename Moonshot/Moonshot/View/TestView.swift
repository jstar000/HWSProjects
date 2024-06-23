//
//  TestView.swift
//  Moonshot
//
//  Created by 임지성 on 3/28/24.
//

import SwiftUI

struct TestView: View {
    var body: some View {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.yellow)
                .frame(width: 200, height: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue)
                        .containerRelativeFrame(.vertical) { height, axis in
                            height * 0.1
                        }
                        .opacity(0.5)
                )
        
    }
}

#Preview {
    TestView()
}
