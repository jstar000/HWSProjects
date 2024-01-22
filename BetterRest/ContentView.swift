//
//  ContentView.swift
//  BetterRest
//
//  Created by 임지성 on 1/22/24.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    
    var body: some View {
        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
        //formatted()는 검색해도 안나오는데 일단 여기서는 double형태의 실수 뒤에 붙는 소수점 0들 없애는 역할
        //in은 stepper의 범위, step은 +- 한 번 누를 때 얼마나 증가감소할지
        DatePicker("Please enter a date", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute)
            .labelsHidden()
        //in은 stepper의 in과 마찬가지로 날짜 범위 설정하는거
        //displayedComponent를 설정하지 않으면 연월일시간 모두 뜨고, 설정하면 거기 시간만 뜨게 할건지 연월일만 뜨게 할건지 선택할 수 있음
        //labelsHidden()은 "Please enter a date"를 보이지 않게 함. VoiceOver가 되려면 저기 뭘 적긴 적어야
        //하는데 보이게 하고싶지 않다면 labelsHidden() 사용하면 됨
        //labelsHidden()은 DatePicker말고 위에 Stepper에도 사용할 수 있고 UI(여기서는 연월일과 시간 선택 버튼,
        //Stepper에서는 +-버튼 등)와 텍스트가 따로 분리된 형태에서 사용할 수 있는 modifier임
    }
}

#Preview {
    ContentView()
}
