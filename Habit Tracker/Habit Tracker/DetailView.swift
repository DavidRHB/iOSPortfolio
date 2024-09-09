//
//  DetailView.swift
//  Habit Tracker
//
//  Created by David Hernandez on 27/08/24.
//

import SwiftUI

struct DetailView: View {
    var activity: Activity
    @ObservedObject var activityList: ActivityList
    
    var body: some View {
        VStack {
            Text(activity.description)
                .padding()
            
            Text("Completed \(activity.completionCount) times")
                .font(.largeTitle)
                .padding()
            
            Button("Mark as Completed") {
                if let index = activityList.activities.firstIndex(of: activity) {
                    var updatedActivity = activity
                    updatedActivity.completionCount += 1
                    activityList.activities[index] = updatedActivity
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle(activity.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
