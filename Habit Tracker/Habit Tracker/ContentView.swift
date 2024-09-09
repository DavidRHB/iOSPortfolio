//
//  ContentView.swift
//  Habit Tracker
//
//  Created by David Hernandez on 27/08/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var activityList = ActivityList()
    @State private var showingAddActivity = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activityList.activities) { activity in
                    NavigationLink {
                        DetailView(activity: activity, activityList: activityList)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(activity.title)
                                .font(.headline)
                            Text("Completed \(activity.completionCount) times")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: removeActivities)
            }
            .navigationTitle("Habit Tracker")
            .toolbar {
                Button {
                    showingAddActivity = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddActivity) {
                AddActivityView(activityList: activityList)
            }
        }
    }
    
    func removeActivities(at offsets: IndexSet) {
        activityList.activities.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
