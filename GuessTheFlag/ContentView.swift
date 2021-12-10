//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Victor Colen on 21/11/21.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

struct ContentView: View { 
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var currentQuestion = 0
    @State private var finalScore = 0
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    
    @State private var rotationAmount = [0.0, 0.0, 0.0]
    @State private var opacityAmount = [1.0, 1.0, 1.0]

    
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
                        FlagView(countryName: countries[number])
                    }
                    .rotation3DEffect(.degrees(rotationAmount[number]), axis: (x: 0, y: 1, z: 0))
                    .opacity(opacityAmount[number])

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
            Text("Your final score was \(finalScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        
        animateFlags(number)
        
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
        
        turnFlagsBackToNormal()

        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        currentQuestion += 1
        
        if currentQuestion == 8 {
            endGame()
        }
        
    }
    
    func animateFlags(_ number: Int) {
        withAnimation {
            rotationAmount[number] += 360
        }
        for i in 0...2 {
            if i != number {
                withAnimation {
                    opacityAmount[i] = 0.75
                }
            }
        }
    }
    
    func turnFlagsBackToNormal() {
        for i in 0...2 {
            withAnimation {
                opacityAmount[i] = 1.0
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FlagView: View {
    var countryName: String
    
    var body: some View {
        Image(countryName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}
