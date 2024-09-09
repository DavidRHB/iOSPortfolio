//
//  AddActivityView.swift
//  Habit Tracker
//
//  Created by David Hernandez on 27/08/24.
//

import SwiftUI

struct AddActivityView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @ObservedObject var activityList: ActivityList

    var body: some View {
        NavigationStack {
            Form {
                TextField("Activity Title", text: $title)
                TextField("Description", text: $description)
            }
            .navigationTitle("Add New Activity")
            .toolbar {
                Button("Save") {
                    let newActivity = Activity(title: title, description: description, completionCount: 0)
                    activityList.activities.append(newActivity)
                    dismiss()
                }
            }
        }
    }
}

