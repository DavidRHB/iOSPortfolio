//
//  ContentView.swift
//  WordScramble
//
//  Created by David Hernandez on 12/08/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var score: Int {
        return usedWords.reduce(0) { $0 + $1.count}
    }
    
    var body: some View {
        
        NavigationStack {
            Text("Score: \(score)")
                .font(.largeTitle)
                .padding()

            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)//this makes it so our textField does not capitalize words
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        .accessibilityElement()
                        .accessibilityLabel("\(word), \(word.count)")
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord) //this means do something when the user presses return on their keyboard. THIS NEEDS TO BE A FUNCTION THAT ACCEPTS NO PARAMETERS AND RETURN NOTHING
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) { } message: {
                Text(errorMessage)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("New Word") {
                    startGame()
                }
            }
        }
    }
    
    
    
    func addNewWord() {
        
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) //this makes our new work lowercased and trims whitespaces and new lines. This standarizes our words.
        
        guard answer.count > 0 else { return } //exit if the remaining string is empty
        
        guard answer.count >= 3 else {
            wordError(title: "Word is too short", message: "Words must be at least 3 letters long.")
            return
        }
        
        guard answer != rootWord else {
            wordError(title: "Word not allowed", message: "You can't just type in the same word!")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from \(rootWord)!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        
        withAnimation { //SIMPLE ANIMATIONS.
            usedWords.insert(answer, at: 0) //here we use insert answer at instead of append, because we want our answer to appear at the very top
        }
        
        newWord = ""
    }
    
    func startGame() {//this method will run when we start our game
        //Step 1. Find the URL for our .txt file with the word list in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            //Step 2. Once located, load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                //Step 3. Split the string up into an array
                let allWords = startWords.components(separatedBy: "\n")
                
                //Step 4. Pick one random word, or use "silkworm" as a default.
                rootWord = allWords.randomElement() ?? "silkworm"
                
                //if all of the above code works, we can exit
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle. ")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
            
        }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    
}



#Preview {
    ContentView()
}
