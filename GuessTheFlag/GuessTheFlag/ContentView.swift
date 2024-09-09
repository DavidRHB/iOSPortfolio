//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by David Hernandez on 25/07/24.
//

import SwiftUI

struct ProminentTitle: ViewModifier { //this is a custom modifier I can pass through other views.
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}

extension View { //this is an extension so I can use my ProminentTitle view modifier more easily
    func prominentTitle() -> some View
    {
        modifier(ProminentTitle())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var currentScore: Int = 0
    @State private var questionsAsked: Int = 0
    @State private var showingFinalScore: Bool = false
    
    //these variables are created for my animations to work
    @State private var selectedFlag = -1
    @State private var flagOpacity = 1.0
    @State private var flagScale: CGFloat = 1.0
    @State private var flagRotation: Double = 0.0
    
    struct FlagImage: View { //this is a Custom View for flag images
        let country: String
        
        var body: some View {
            Image(country)
                .clipShape(.capsule)
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                    .prominentTitle()
                
                VStack(spacing: 15) {
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                                .opacity(selectedFlag == number ? 1.0 : flagOpacity)
                                .scaleEffect(selectedFlag == number ? 1.0 : flagScale)
                                .rotation3DEffect(.degrees(selectedFlag == number ? flagRotation : 0), axis: (x: 0, y: 1, z: 0))
                        }}
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Question \(questionsAsked)/8")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
                Text("Score: \(currentScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your Score is \(currentScore)")
        }
        .alert("Game Over!", isPresented: $showingFinalScore) {
            Button("Restart", action: resetGame)
        } message: {
            Text("You scored \(currentScore)/8")
        }
    }
    
    func flagTapped(_ number: Int) {
        
        selectedFlag = number
        
        if number == correctAnswer {
            scoreTitle = "Correct!"
            currentScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        withAnimation {
            flagRotation += 360
            flagOpacity = 0.25
            flagScale = 0.8
            
        }
        showingScore = true
        questionsAsked += 1
        
    }
    
    func askQuestion() {
        if questionsAsked == 8 {
            showingFinalScore = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            
            //reset animation state
            selectedFlag = -1
            flagOpacity = 1.0
            flagScale = 1.0
            flagRotation = 0.0
        }
    }
    
    func resetGame() {
        currentScore = 0
        questionsAsked = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        //reset animation state
        selectedFlag = -1
        flagOpacity = 1.0
        flagScale = 1.0
        flagRotation = 0.0
    }
}
#Preview {
    ContentView()
}
