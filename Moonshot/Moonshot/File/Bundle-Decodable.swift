//
//  BundleDecodable.swift
//  Moonshot
//
//  Created by 임지성 on 3/22/24.
//

import Foundation

/// astronaut.json을 Astronaut인스턴스의 dictionary로 만들기 위해
/// Bundle을 통해 file의 경로를 찾고 Data인스턴스로 load한 다음 JSONDecoder에 넘겨줌
/// 전에는 ContentView에서 이걸 했었지만 더 좋은 방법이 있음
/// Bundle에 대한 extension을 이용하면 one centralized place에서 작업 수행 가능!

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        //원래 형태는 JSONDecoder.DateDecodingStrategy.formatted(formatter)
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle")
        }
        /// 파일로부터 가져온 data객체를 [String: Astronaut]형태의 딕셔너리로 만드는 코드
        /// .self를 적는 이유는 iExpense에 self 검색해보기(걍 swift가 이해할 수 있도록 하기 위함이라고 함)
        
        return loaded
        
        /// 전에 WordScramble에서도 이거랑 거의 비슷한 방법으로 Bundle에서 파일을 찾아 데이터를 가져왔었음
        /// 이 코드와의 차이점은, 그때는 @State private var rootWord라는 값에 load한 데이터를 String(contentsOf:)를 통해
        /// JSON데이터를 String으로  바로 변환해 집어넣었었고,
        /// 여기서는 Codable로 선언된 struct에 데이터를 집어넣으므로 Codable프로토콜에 맞추기 위해 Data(contentsOf:)를 통해
        /// JSON데이터를 Data객체에 집어넣는다는 차이가 있음
    }
}
