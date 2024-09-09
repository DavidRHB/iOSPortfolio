//
//  ContentView.swift
//  RockPapersScissors
//
//  Created by David Hernandez on 31/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var machinePossiblePick = ["Rock 🪨", "Paper 📄", "Scissors ✂️"]
    @State private var machinePick = Int.random(in: 0...2)
    @State private var playerPick = ["Rock 🪨", "Paper 📄", "Scissors ✂️"]
    @State private var turnTracker = 0
    @State private var pointTracker = 0
    @State private var message = ""
    @State private var showFinalScore: Bool = false
    @State private var showCurrentScore: Bool = false
   
    
    var body: some View {
        NavigationStack{
            Spacer()
            Text("Rock, Paper, Scissors")
                .font(.largeTitle)
                .bold()
            
            VStack {
                Spacer()
                Text("The machine has picked")
                    .font(.title)
                Text("\(machinePossiblePick[machinePick])")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.system(size: 70))
            }
            VStack {
                Spacer()
                Text("What will you pick?")
                    .font(.title)
        
                
                HStack {
                    ForEach(playerPick, id: \.self) { choice in
                        Button {
                            handleChoice(choice)
                        } label: {
                            Text(choice)
                                .font(.title2)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            
                            
                        }
                    }
                }
            }
            Spacer()
            .padding()
            VStack {
                Text("Your Score is \(pointTracker)/10")
                Text("Turn \(turnTracker)/10")
            }
            .padding()
            .font(.title)
            .bold()
            
        }
        .alert(message, isPresented: $showCurrentScore) {
            Button("Continue", action: endScreen)
        }
        .alert("Game Over", isPresented: $showFinalScore) {
            Button("Play Again", action: resetGame)
        } message: {
            Text("You scored \(pointTracker) out of 10!")
        }
    }
    func handleChoice(_ playerChoice: String) {
        let machineChoice = machinePossiblePick[machinePick]
        
        if (machineChoice == "Rock 🪨" && playerChoice == "Paper 📄") || (machineChoice == "Paper 📄" && playerChoice == "Scissors ✂️") || (machineChoice == "Scissors ✂️" && playerChoice == "Rock 🪨")
        {
            pointTracker += 1
            message = "Congratulations! You get a point!"
        } else if playerChoice == machineChoice {
            message = "It's a draw!"
        } else {
            message = "You lost this round. Try again!"
            if pointTracker > 0 {
                pointTracker -= 1
            }
        }
            
        
        machinePick = Int.random(in: 0...2)
        turnTracker += 1
        showCurrentScore = true
        
    
    }
    
    func endScreen() {
        if turnTracker == 10 {
            showFinalScore = true
        }
    }
    
    func resetGame() {
        pointTracker = 0
        turnTracker = 0
        message = ""
        machinePick = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
