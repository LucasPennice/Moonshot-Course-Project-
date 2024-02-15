//
//  MissionView.swift
//  Moonshot
//
//  Created by Lucas Pennice on 14/02/2024.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal){width, axis in width * 0.6}
                    
                    Text(mission.formattedLaunchDate)
                        .font(.title.bold())
                    
                    Divider()
                        .padding([.horizontal, .vertical])
                    
                    VStack(alignment: .leading){
                        Text("Mission Highlights")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                        
                        Text(mission.description)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding([.horizontal, .vertical])
                 
                    Text("Crew")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(crew, id: \.role){crewMember in
                                NavigationLink{
                                    AstronautView(astronaut: crewMember.astronaut)
                                } label: {
                                    HStack{
                                        Image(crewMember.astronaut.id)
                                            .resizable()
                                            .frame(width: 104, height: 72)
                                            .clipShape(.capsule)
                                            .overlay(
                                                Capsule().strokeBorder(.white, lineWidth: 1))
                                        
                                        
                                        VStack(alignment: .leading){
                                            Text(crewMember.astronaut.name)
                                                .foregroundStyle(.white)
                                                .font(.headline)
                                            
                                            Text(crewMember.role)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle(mission.displayName)
            .navigationBarTitleDisplayMode(.large)
            .background(.darkBackground)
        }
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        
        self.crew = mission.crew.map{ member in
            guard let astronaut = astronauts[member.name] else {fatalError("Astronaut \(member.name) in mission.json not found in astronauts.json")}
            
            return CrewMember(role: member.role, astronaut: astronaut)
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts : [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    return MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
