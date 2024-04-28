//
//  ContentView.swift
//  Bookworm
//
//  Created by 임지성 on 4/24/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    //여기도 modelContext가 있고 AddBookView에도 modelContext가 있는데,
    //@Environment속성은 앱 전체의 상태를 관리하는 목적으로 사용하는 거니까 아마 두 modelContext는
    //똑같은 modelContext일 듯
    @Query var books: [Book] //modelContext에 넣고싶은 데이터 타입을 @Query로 선언
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    //SwiftModel data가 Identifiable프로토콜을 따르므로 id 줄 필요 없음
                    
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                    .foregroundStyle(book.isRating1 ? .red : .black)
                                    //.foregroundStyle(book.rating == 1 ? .red : .primary)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            //find this book in our query
            let book = books[offset]
            
            //delete it from the context
            modelContext.delete(book)
        }
    }
}

#Preview {
    ContentView()
}
