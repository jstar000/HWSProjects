//
//  ListView.swift
//  Moonshot
//
//  Created by 임지성 on 4/4/24.
//

import SwiftUI

struct ListView: View {
    let astronauts: [String: Astronaut]
    let missions: [Mission]
    
    var body: some View {
        List(missions) { mission in
            NavigationLink {
                MissionView(mission: mission, astronauts: astronauts)//목적지 뷰
            } label: {
                HStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    VStack {
                        Text(mission.displayName)
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text(mission.formattedLaunchDate)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Moonshot")
        .listStyle(.plain)
        .listRowBackground(Color.darkBackground)
        .preferredColorScheme(.dark) //다크모드 강제
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return ListView(astronauts: astronauts, missions: missions)
        .preferredColorScheme(.dark)
}
