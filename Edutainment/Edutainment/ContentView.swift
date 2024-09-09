//
//  ContentView.swift
//  Edutainment
//
//  Created by David Hernandez on 15/08/24.
//

import SwiftUI

struct ContentView: View {
    @State private var multiplicationTable = 2
    @State private var numberOfQuestions = 5
    @State private var questions = [Question]()
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var isGameActive = false
    @State private var showingScore = false
    
    
    var body: some View {
        NavigationStack {
            if isGameActive {
                gameView
            } else {
                settingsView
            }
        }
        .alert("Game Over", isPresented: $showingScore) {
            Button("Play Again", action: resetGame)
        } message: {
            Text("Your score is \(score) out of \(numberOfQuestions)")
        }
    }
        
    
    
    var settingsView: some View {
        Form {
            Section(header: Text("Select the multiplication table")) {
                Stepper("Up To \(multiplicationTable)", value: $multiplicationTable, in: 2...12)
            }
            
            Section(header: Text("Select the number of questions")) {
                Picker("Number of questions", selection: $numberOfQuestions) {
                    ForEach([5, 10, 20], id: \.self) {
                        Text("\($0) questions")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Button("Start Game") {
                startGame()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

        }
        .navigationTitle("Settings")
    }
    
    var gameView: some View {
        VStack {
            Text("Question \(currentQuestionIndex + 1)  / \(numberOfQuestions)")
                .font(.headline)
            
            Text("\(questions[currentQuestionIndex].text)")
                .font(.largeTitle)
                .padding()
            
            TextField("Your answer", text: $userAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            Button("Submit") {
                checkAnswer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .navigationTitle("What is the answer?")
        
    }
    
    func startGame() {
        generateQuestions()
        isGameActive = true
        currentQuestionIndex = 0
        score = 0
        userAnswer = ""
    }
    
    func generateQuestions() {
        questions = (1...numberOfQuestions).map { _ in
            let firstNumber = Int.random(in: 1...multiplicationTable)
            let secondNumber = Int.random(in: 1...12)
            return Question(text: "\(firstNumber) x \(secondNumber)", answer: firstNumber * secondNumber)
        }
    }
    
    func checkAnswer() {
        let correctAnswer = questions[currentQuestionIndex].answer
        if Int(userAnswer) == correctAnswer {
            score += 1
        }
        
        if currentQuestionIndex + 1 < numberOfQuestions {
            currentQuestionIndex += 1
            userAnswer = ""
        } else {
            showingScore = true
        }
    }
    
    func resetGame() {
        isGameActive = false
    }
    
    struct Question {
        var text: String
        var answer: Int
    }
}

#Preview {
    ContentView()
}
