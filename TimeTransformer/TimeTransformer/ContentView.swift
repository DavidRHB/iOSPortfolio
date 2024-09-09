//
//  ContentView.swift
//  TimeTransformer
//
//  Created by David Hernandez on 16/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var timeInput: Double = 60
    @State private var timeInputType = "Seconds"
    @State private var timeOutputType = "Seconds"
    @FocusState private var inputAmountIsFocused: Bool
    
    let timeTypes = ["Seconds", "Minutes", "Hours"]
    
    var finalOutput: Double {
        var seconds: Double
        
        // Convert input to seconds
        switch timeInputType {
        case "Minutes":
            seconds = timeInput * 60
        case "Hours":
            seconds = timeInput * 3600
        default:
            seconds = timeInput
        }
        
        // Convert seconds to the selected output type
        switch timeOutputType {
        case "Minutes":
            return seconds / 60
        case "Hours":
            return seconds / 3600
        default:
            return seconds
        }
    }
    
    
    var body: some View {
        NavigationStack() {
            Form {
                Section ("Enter amount and select unit of time"){
                    TextField("Enter your Amount here", value: $timeInput, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputAmountIsFocused)
                    
                    Picker("Select your input type", selection: $timeInputType) {
                        ForEach(timeTypes, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section ("Select unit of time to convert to:"){
                    Picker("Select your output type", selection: $timeOutputType) {
                        ForEach(timeTypes, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
                .pickerStyle(.segmented)
                Section("Your converted amount is") {
                    Text(finalOutput, format: .number.precision(.fractionLength(2)))
                }
                
            }
            .navigationTitle("TimeTransformer 🕰️")
            .toolbar {
                if inputAmountIsFocused {
                    Button("Done") {
                        inputAmountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
