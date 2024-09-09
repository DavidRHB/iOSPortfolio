//
//  DataModel.swift
//  Habit Tracker
//
//  Created by David Hernandez on 27/08/24.
//

import SwiftUI

//this struct will save our activity or habit
struct Activity: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var description: String
    var completionCount: Int
}
//Observable class that holds Activity array
@Observable class ActivityList: ObservableObject {
    var activities = [Activity]() {
        didSet {
            saveActivities()
        }
    }
    
    init() {
        loadActivities()
    }
    
    //Save activities to UserDefaults()
    private func saveActivities() {
        if let encoded = try? JSONEncoder().encode(activities) {
            UserDefaults.standard.set(encoded, forKey: "Activities")
        }
    }
    
    //Load the activities from UserDefaults
    private func loadActivities() {
        if let savedData = UserDefaults.standard.data(forKey: "Activitites") {
            if let decoded = try? JSONDecoder().decode([Activity].self, from: savedData) {
                activities = decoded
                return
            }
        }
        activities = []
    }
}
