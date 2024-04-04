//
//  ContentView.swift
//  Moonshot
//
//  Created by 임지성 on 3/10/24.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]

    @AppStorage("isViewStyleList") private var isViewStyleList = true
    
    
    
    var currentStyle: String {
        isViewStyleList ? "Change to Grid" : "Change to List"
    }

    var body: some View {
        NavigationStack {
            Group {
                if isViewStyleList {
                    ListView(astronauts: astronauts, missions: missions)
                } else {
                    GridView(astronauts: astronauts, missions: missions)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(currentStyle) {
                        isViewStyleList.toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
