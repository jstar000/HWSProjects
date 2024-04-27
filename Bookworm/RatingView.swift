//
//  RatingView.swift
//  Bookworm
//
//  Created by 임지성 on 4/25/24.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int 
    
    var label = "" //rating을 주기 전에 default로 띄울 문구
    var maximumRating = 5
    var offImage: Image? //star가 hilighted되지 않았을 때(nil for the off image)
                         //만약 offImage 자체가 nil일 때는 그냥 on image를 넣을 거임
                         //offImage 없어도 잘 동작하는데 이게 왜 있어야되지?
    var onImage = Image(systemName: "star.fill") //filled star for the on image
    var offColor = Color.gray //star가 hilighted되지 않았을 때
    var onColor = Color.yellow //star가 hilighted됐을 때
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                Button {
                    rating = number
                } label: {
                    image(for: number)
                        .foregroundStyle(number > rating ? offColor : onColor)
                }
            }
        }
        .buttonStyle(.plain)
        /// 이 modifier가 무조건 있어야 함
        /// AddBookView에는 Form에 의한 row가 있고 그 row 중 하나에서 RatingView를 호출하고 있음
        /// SwiftUI는 Form이나 List의  'row 전체'가 tappable하다고 판단하는데,
        /// 따라서 우리가 만든 별 모양 버튼 하나하나를 탭할 수 있는게 아니라 그냥 Form이나 List의 row 전체가 탭 가능한 영역이 됨
        /// 이 경우 여러 개의 버튼이 있으므로 해당 row의 버튼을 탭하면 그 모든 버튼을 탭한 것으로 판단하고
        /// rating이 1, 2, 3, 4에서 5로 변하게 됨. 따라서 어딜 탭하든 간에 결과는 무조건 5가 되는 것
        /// 이걸 방지하기 위해 .buttonStyle(.plain) modifier를 달아주는 것!
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            offImage ?? onImage //return 생략
            //offImage가 nil이면 onImage 반환
        } else {
            onImage //return 생략
        }
    }
}

#Preview {
    RatingView(rating: .constant(4))
}
