//
//  ContentView.swift
//  WordScramble
//
//  Created by 임지성 on 2/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]() //이미 사용한 단어 저장
    @State private var rootWord = "" //root word for them to spell other words from
    @State private var newWord = "" //text field에 바인딩할 string
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        //문자를 입력할 때 첫글자가 대문자로 되는거 방지(.never, .sentence 등 다양한 옵션 있음)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            //SF Symbol에는 숫자.circle이나 숫자.circle.fill이라는 symbol이 있으므로 그거 사용해서 문자열의 길이 나타내는 코드(숫자범위: 0부터 50까지)
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            //사용자가 키보드에서 return을 누르면 addNewWord()를 실행하고 싶음. 이럴 때는 onSubmit() modifier를 view hierarchy 어딘가에 추가하면 됨(버튼에 직접적으로 붙일 수도 있는데, 사실 상 그냥 뷰의 어디에든 추가하면 됨(어떤 text가 submitted되든 onSubmit()가 실행됨))
            //onSubmit()는 아무런 파라미터도 없고 어떤 것도 리턴하지 않는 함수를 인자로 받음
        }
    }
    
    func addNewWord() {
        // 소문자로 바꾸고 trim하기(대소문자 때문에 같은 단어 중복시키지 않기 위해)
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // answer가 empty라면 exit
        guard answer.count > 0 else { return }
        //guard문은 guard let result = variable else { return } 이렇게 unwrap할 때만 사용하는게 아니라 어떤 condition에도 사용할 수 있음
        //여기서도 answer.count > 0, 즉 answer배열이 빈 배열이 아닌 경우 다음 코드로 넘어가고, guard문의 조건을 만족하지 않는 경우 else구문이 실행되어 종료됨
        
        //extra vlidation
        
        //usedWords배열의 0번째 element에 answer라는 string을 삽입함
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        //append(answer)가 아니라 insert(answer, at: 0)을 사용한 이유
        //append()를 사용하면 추가한 string이 list의 마지막에 위치하게 되는데, 이런 경우 list항목이 계속해서 늘어날 경우 screen에서 사라질 수 있음
        //insert()를 통해 배열의 0번째 element에 새로운 string을 삽입하면 새롭게 추가된 문자열이 계속 스크린의 가장 위에 보임!
        
        newWord = ""
    }
}

#Preview {
    ContentView()
}
