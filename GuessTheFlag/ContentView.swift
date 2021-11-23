//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Victor Colen on 21/11/21.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var currentQuestion = 0
    @State private var finalScore = 0
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .top, endPoint: .bottom)
            
                .ignoresSafeArea()
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.light)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .underline()
                    
                }
                
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        Image(countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    }
                }
                
                Text("Your score: \(score)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button ("Continue", action: askQuestion)
        } message: {
            Text("You score is \(score)")
        }
        
        .alert("The game has ended", isPresented: $showingFinalScore) {
            Button ("Play Again", action: askQuestion)
        } message: {
            Text("You final score was \(finalScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])!"
        }
        
        showingScore = true
    }
    
    func endGame() {
        showingFinalScore = true
        finalScore = score
        score = 0
        currentQuestion = 0
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        currentQuestion += 1
        
        if currentQuestion == 8 {
            endGame()
        }
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
