//
//  ContentView.swift
//  PrettyPrint
//
//  Created by David Hernandez on 4/09/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext //Access SwiftData model context
    @State private var users: [User] = []
    
    var body: some View {
            NavigationStack {
                List(users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)
                            Text(user.isActive ? "Active" : "Inactive")
                                .foregroundColor(user.isActive ? .green : .red)
                                .font(.subheadline)
                        }
                    }
                }
                .navigationTitle("Users")
                .task {
                    if users.isEmpty {
                        await fetchData()
                    }
                }
            }
        }
    
    func fetchData() async {
        let urlString = "https://www.hackingwithswift.com/samples/friendface.json"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedUsers = try decoder.decode([User].self, from: data)
            
            for user in decodedUsers {
                modelContext.insert(user)
            }
            
            users = decodedUsers
        } catch {
            print("Failed to load data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
