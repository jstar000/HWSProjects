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
    
    var wordsArray = [String]()
    
    //에러 알림용c
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
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
            .listStyle(.grouped)
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            //사용자가 키보드에서 return을 누르면 addNewWord()를 실행하고 싶음. 이럴 때는 onSubmit() modifier를 view hierarchy 어딘가에 추가하면 됨(버튼에 직접적으로 붙일 수도 있는데, 사실 상 그냥 뷰의 어디에든 추가하면 됨(어떤 text가 submitted되든 onSubmit()가 실행됨))
            //onSubmit()는 아무런 파라미터도 없고 어떤 것도 리턴하지 않는 함수를 인자로 받음
            .onAppear(perform: getWordsArray)
            .alert(errorTitle, isPresented: $showingError) {
                //Button("OK") {}
                //alert에 아무런 버튼도 선언하지 않으면 자동으로 alert를 dismiss하게 만드는 "OK"버튼이 생성됨
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                Button("Restart", action: restartGame)
            }
        }
    }
    
    func addNewWord() {
        // 소문자로 바꾸고 trim하기(대소문자 때문에 같은 단어 중복시키지 않기 위해)
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // answer가 empty라면 exit
        guard answer.count > 0 else { return }
        //guard문은 guard let result = variable else { return } 이렇게 unwrap할 때만 사용하는게 아니라 어떤 condition에도 사용할 수 있음
        //여기서도 answer.count > 0, 즉 answer배열이 빈 배열이 아닌 경우 다음 코드로 넘어가고, guard문의 조건을 만족하지 않는 경우 else구문이 실행되어 종료됨
        
        guard wordLimit(word: answer) else {
            wordError(title: "Word does not fit standard", message: "Do not use words that are shorter than 3 letters, or are just same as our root word")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        //usedWords배열의 0번째 element에 answer라는 string을 삽입함
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        //append(answer)가 아니라 insert(answer, at: 0)을 사용한 이유
        //append()를 사용하면 추가한 string이 list의 마지막에 위치하게 되는데, 이런 경우 list항목이 계속해서 늘어날 경우 screen에서 사라질 수 있음
        //insert()를 통해 배열의 0번째 element에 새로운 string을 삽입하면 새롭게 추가된 문자열이 계속 스크린의 가장 위에 보임!
        
        newWord = ""
    }
    
    func getWordsArray() {
        //1. app bundle에서 start.txt의 URL 찾기
        //여러가지 bundle들 중 main bundle에 접근하고 싶다면 Bundle.main.url() 사용
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            //2. start.txt를 string으로 load하기
            if let startWords = try? String(contentsOf: startWordsURL) {
                //3. load한 string을 string배열로 바꾸기
                wordsArray = startWords.components(separatedBy: "\n")
            }
        }
        
        //여기 왔다면 파일을 찾거나 로드하는 과정에 문제가 발생한 것
        fatalError("Could not load start.txt from bundle")
    }
    
    func startGame() {
        getWordsArray()
        
       //랜덤 단어 뽑기, 배열이 비었을 경우 'silkworm'을 default값으로 주기
        rootWord = wordsArray.randomElement() ?? "silkworm"
    }
    
    func isOriginal(word: String) -> Bool {
        //.contains 입력하면 .contains(where:) 뭐 이런거 나오는데 그런 거 없이 바로 string을 집어넣어도 되는 듯
        !usedWords.contains(word)
    }
    
    //word는 사용자가 입력한 단어
    //for문을 돌면서 사용자가 입력한 letter가 rootWord에 있는 letter인지 확인하고, 만약 없는 letter라면 rootWord와 다른 단어를 입력한 것이므로 false를 return함
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                //배열의 앞에서부터 조회해서 첫번째 일치하는 값의 index를 반환
                tempWord.remove(at: pos)
                //pos값의 element를 삭제함
            } else {
                return false
            }
        }
        
        return true
    }
    
    func wordLimit(word: String) -> Bool {
        if word.count < 3 { return false }
        if word == rootWord { return false }
        return true
    }
    
    func isReal(word: String) -> Bool {
        //Swift string을 Objective-C string으로 바꾸려면
        
        let checker = UITextChecker()
        //1. UITextChecker인스턴스를 생성
        let range = NSRange(location: 0, length: word.utf16.count)
        //2. NSRange인스턴스를 생성하고 UTF-16 count로 원하는 string(여기서는 word)의 길이를 알려줌
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        //3. rangeOfMisspelledWord를 통해 misspelling 탐색
        //   rangeOfMisspelledWord는 misspelling이 있으면 어디에 misspelled word가 있는지 알려주는     NSRange를 반환하고, misspelling이 없으면 NSNotFound라는 special value를 반환함
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func restartGame() {
        usedWords.removeAll()
        rootWord = wordsArray.randomElement() ?? "silkworm"
        newWord = ""
    }
}

#Preview {
    ContentView()
}
