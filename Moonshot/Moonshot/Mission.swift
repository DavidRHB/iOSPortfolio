//
//  Mission.swift
//  Moonshot
//
//  Created by David Hernandez on 19/08/24.
//

import Foundation


struct Mission: Codable, Identifiable {
    struct CrewRole: Codable { //podes meter un struct dentro de otro. Un nested struct
        let name: String
        let role: String
    }
    
    
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo\(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
}
