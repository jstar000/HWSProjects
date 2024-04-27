//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by 임지성 on 4/27/24.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int
    
    var body: some View {
        /// Tip: I used numbers in my text because emoji can cause havoc(혼란) with e-readers,
        /// but you should replace those with whatever emoji you think represent the various ratings.
        /// 뭔 말이야?
        
        switch rating {
        case 1:
            Text("1")
        case 2:
            Text("2")
        case 3:
            Text("2")
        case 4:
            Text("2")
        default:
            Text("5")
        }
    }
}

#Preview {
    EmojiRatingView(rating: 3)
}
