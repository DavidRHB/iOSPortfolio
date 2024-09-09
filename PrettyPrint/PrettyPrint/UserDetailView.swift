//
//  UserDetailView.swift
//  PrettyPrint
//
//  Created by David Hernandez on 4/09/24.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            
            Text("Age: \(user.age)")
            Text("Company: \(user.company)")
            Text("Email: \(user.email)")
            Text("Address: \(user.address)")
            Text("About: \(user.about)")
            
            Text("Friends:")
                .font(.headline)
                .padding(.top)
            
            List(user.friends) { friend in
                Text(friend.name)
            }
            
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
