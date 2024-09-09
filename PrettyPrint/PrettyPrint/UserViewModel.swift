//
//  UserViewModel.swift
//  PrettyPrint
//
//  Created by David Hernandez on 4/09/24.
//

import Foundation

//This model will handle fetching data from the URL given by Paul and decoding it into our User objects using URLSession and Codable

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    
    func fetchUsers() async {
        guard users.isEmpty else { return } // Prevent re-downloading data
        
        let urlString = "https://www.hackingwithswift.com/samples/friendface.json"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601 //Decode ISO 8601 date format
            let users = try decoder.decode([User].self, from: data)
            self.users = users
        } catch {
            print("Failed to fetch or decode users: \(error.localizedDescription)")
        }

    }
    
}

//the code above supposedly decodes our JSON file
