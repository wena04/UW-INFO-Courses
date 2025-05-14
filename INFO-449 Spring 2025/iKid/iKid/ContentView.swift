//
//  ContentView.swift
//  iKid
//
//  Created by Anthony  Wen on 4/22/25.
//

import SwiftUI

struct Joke {
    let category: String
    let icon: String
    let question: String
    let punchline: String
    let imageName: String?
}

struct KnockKnockJoke {
    let category: String
    let icon: String
    let lines: [String]
}

struct JokeView: View {
    let joke: Joke
    @State private var showPunchline = false
    
    var body: some View {
        VStack {
            Text(joke.question)
                .font(.title)
                .padding(.horizontal, 10.0)
                .padding(.top, 40.0)
                .lineLimit(nil)
            
            if (showPunchline) {
                Text(joke.punchline)
                    .font(.headline)
                    .padding(.horizontal, 10.0)
                    .padding()
                
                if let imageName = joke.imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300)
                        .padding(.bottom)
                }
            }
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    self.showPunchline.toggle()
                }
            }) {
                Text(
                    showPunchline ? "Hide Punchline" : "Next"
                )
                .padding()
            }
            .buttonStyle(prettyButton())
        }
    }
}

struct KnockKnockJokeView: View {
    let joke: KnockKnockJoke
    @State private var currentLineIndex = 0
    
    var isLastLine: Bool {
        currentLineIndex == joke.lines.count - 1
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(0..<currentLineIndex + 1, id: \.self) { index in
                        if (index % 2 == 0) {
                            Text(self.joke.lines[index])
                                .font(.title)
                                .padding(.horizontal, 10.0)
                                .padding(.vertical, 20.0)
                                .lineLimit(nil)
                        } else {
                            Text(self.joke.lines[index])
                                .font(.headline)
                                .padding(.horizontal, 10.0)
                                .padding(.vertical, 5.0)
                                .lineLimit(nil)
                        }
                    }
                }
            }
            .padding(.vertical, 10.0)
            
            Button(action: {
                withAnimation {
                    if self.isLastLine {
                        self.currentLineIndex = 0
                    } else {
                        self.currentLineIndex += 1
                    }
                }
            }) {
                Text(
                    self.isLastLine ? "Hide Punchline" : "Next"
                )
                .padding()
            }
            .buttonStyle(prettyButton())
        }
    }
    
}

struct prettyButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: 200.0, minHeight: 0, maxHeight: 20.0)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(30.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .padding(.bottom, 60.0)
    }
}

struct ContentView: View {
    let jokes = [
        Joke(
            category: "Good",
            icon: "face.smiling.inverse",
            question: "Why was there a bug in the computer?",
            punchline: "It was looking for a byte to eat!",
            imageName: "funny"
        ),
        Joke(
            category: "Pun",
            icon: "balloon.2.fill",
            question: "Why don't scientists trust atoms?",
            punchline: "Because they make up everything!",
            imageName: nil
        ),
        Joke(
            category: "Dad",
            icon: "figure.fall",
            question: "What’s Forrest Gump’s password?",
            punchline: "1forest1",
            imageName: nil
        )
    ]
    
    let kkj = KnockKnockJoke(
        category: "Knock Knock",
        icon: "door.left.hand.closed",
        lines: [
            "Knock knock.",
            "Who's there?",
            "Honey bee.",
            "Honey bee. who?",
            "Honey bee a dear and get that for me, please!"
        ]
    )
    
    var body: some View {
        TabView {
            ForEach(jokes, id: \.category) { joke in
                NavigationView {
                    JokeView(joke: joke)
                        .navigationBarTitle("\(joke.category) Joke")
                }
                .tabItem {
                    Image(systemName: joke.icon)
                    Text(joke.category)
                }
            }
            
            NavigationView {
                KnockKnockJokeView(joke: kkj)
                    .navigationBarTitle("\(kkj.category) Joke")
            }
            .tabItem {
                Image(systemName: kkj.icon)
                Text(kkj.category)
            }
        }
    }
}


#Preview {
    ContentView()
}
