//
//  EditView.swift
//  BucketList
//
//  Created by 임지성 on 6/22/24.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String
    @State private var description: String
    var location: Location
    var onSave: (Location) -> Void
    
    enum LoadingState {
        case loading, loaded, failed
        // 케이스의 타입을 명시할 필요는 없음
        // 열거형의 케이스는 자동으로 해당 enum의 타입, 즉 LoadingState라는 타입을 가짐
    }
    @State private var loadingState = LoadingState.loading // loading state 저장
    @State private var pages = [Page]() // fetch가 끝났을 때 Wikipedia pages 저장
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Nearby...") {
                    switch loadingState {
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading...")
                    case .failed:
                        Text("Please try again later")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation)
                    dismiss()
                }
                
            }
            .task {
                await fetchNearbyPlaces()
                // 이 함수는 뷰가 나타나자마자 실행돼야 함
            }
        }
    }
    
    func fetchNearbyPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // data(from:)은 네트워크 요청에 관한 메타데이터와 URL로부터의 데이터를 튜풀로 반환함
            // 메타데이터는 필요 없으므로 (data, _)와 같이 반환받으면 됨
            
            // we got some data back!
            let items = try JSONDecoder().decode(Result.self, from: data)
            
            // success - convert the array values to our pages array
            pages = items.query.pages.values.sorted()
            // .values는 딕셔너리의 모든 value를 포함하는 컬렉션을 반환함
            // sorted()는 호출된 배열을 정렬한 새로운 배열을 반환함(원래 배열은 변하지 않음)
            loadingState = .loaded
        } catch {
            // if we're still here it means the request failed somehow
            loadingState = .failed
        }
    }
}

#Preview {
    EditView(location: .example) { _ in }
}
