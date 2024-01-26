//
//  ContentView.swift
//  BetterRest
//
//  Created by 임지성 on 1/22/24.
//

import CoreML //보통 여러 개 import할 때는 알파벳 순서로 import
import SwiftUI

struct ContentView: View {
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    //amend 확인용 코드 수정
    
    @State private var sleepAmount = 8.0 //얼마나 자고싶은지
    @State private var wakeUp = defaultWakeTime //언제 일어나고싶은지
    @State private var coffeeAmount = 1 //하루에 커피를 얼마나 마시고싶은지
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                    //언제 일어나고 싶은지 날짜가 아니라 '시간'이 궁금하므로 .hourAndMinute 선택
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                    //WTF ->
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedTime() {
        do {
            //코드 진행 설명은 노션 Project4 참고
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            //1. SleepCalculator클래스의 인스턴스 생성하기(configuration은 '구성'이라는 뜻)
            //-> 이 모델 인스턴스로 데이터를 읽은 후 예측 데이터를 만들 수 있음
            //do-catch문은 Core ML이 두 군데서 에러를 만들 수 있으므로 사용
            //<- model을 load할 때와(바로 위 코드), 예측 데이터를 만들 때 에러 가능
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            //여기서 [.hour, .minute]이라는 건, dateComponent에는 year, month, day, hour, minute, second, timezone 등 다양한 component가 있는데 거기서 hour와 minute component를 얻어오겠다는 의미로 사용되는 듯!
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            //여기서 Core ML 알고리즘을 통해 계산됨
            let sleepTime = wakeUp - prediction.actualSleep
            //wakeUp의 자료형은 Date인데, Date에서 초단위 값인 prediction.actualSleep을 빼면 결과는 그냥 Date형으로 자동 계산됨
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            //sleepTime은 string이 아니라 Date이므로 이걸 .formatted()를 통해 적절히 변환해야 함(코드에 대한 자세한 설명은 없음)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        
        showingAlert = true
    }
}

#Preview {
    ContentView()
}
