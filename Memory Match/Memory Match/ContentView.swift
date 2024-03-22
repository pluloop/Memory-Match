//
//  ContentView.swift
//  Memory Match
//
//  Created by StudentAM on 3/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{ // to switch to game when button pressed
            ZStack{ //
                Image("start") // display start image
                    .resizable() // to change size
                    .aspectRatio(contentMode: .fill) // to use image on all the screen space
                    .edgesIgnoringSafeArea(.all) // to use image on all the screen space
                VStack{ // display title and button on separate lines
                    Spacer() // for spacing
                    
                    Text("EmojiMatch").font(.custom("FuzzyBubbles-Bold", fixedSize: 40)) // to display title (using font custom "Fuzzy Bubbles Bold" and size 40)
                        .padding(.horizontal, 75) // horizontal length of title
                        .padding(.vertical, 25) // vertical length of title
                        .foregroundColor(.white) // make text of title white
                        .background(Color.orange) // make button orange
                        .cornerRadius(8) // make corners of button more round
                        .font(.system(size: 40)) // make text of button bigger
                    
                    Spacer() // for spacing
                    
                    NavigationLink(destination: CardGameView()){ // for going to game view once button clicked
                        Text("Start").font(.custom("FuzzyBubbles-Bold", fixedSize: 40)) // text for button to know how to start game (using font custom "Fuzzy Bubbles Bold" and size 40)
                            .padding(.horizontal, 75) // horizontal length of button
                            .padding(.vertical, 25) // vertical length of button
                            .foregroundColor(.white) // make text of button white
                            .background(Color.blue) // make color of button blue
                            .cornerRadius(8) // make corners of button more round
                            .font(.system(size: 40)) // make text of button bigger
                    }
                    
                    Spacer() // for spacing
                }
            }
        }
    }
}

struct CardGameView: View { // to show stuff for game
    @State var emojis = ["😀", "😀" ,"😁", "😁", "😂", "😂", "🤣", "🤣", "😃", "😃", "😄", "😄",].shuffled() // to hold emojis (shuffled)
    @State private var pickOne: Int = -1 // to store flip 1
    @State private var pickTwo: Int = -1 // to store flip 2
    @State private var score: Int = 0 // to store score and display later
    @State private var button: [Bool] = [false, false, false, false, false, false, false, false, false, false, false, false] // to keep track of which cards are flipped
    
    let columns: [GridItem] = [ // to display emojis and cards in rows and columns
        GridItem(.fixed(90), spacing: nil, alignment: nil), // column 1
        GridItem(.fixed(90), spacing: nil, alignment: nil), // column 2
        GridItem(.fixed(90), spacing: nil, alignment: nil), // column 3
    ]
    
    var body: some View { // to display stuff
        ZStack{ // for emojis, cards, buttons, etc to be on top of background
            Image("game") // to display game image background
                .resizable() // to change size of background
                .aspectRatio(contentMode: .fill) // to use image on all the screen space
                .edgesIgnoringSafeArea(.all) // to use image on all the screen space
            VStack{ // display text, emojis, cards, etc on separate lines
                Text("Current Score: \(score)").font(.custom("FuzzyBubbles-Regular", fixedSize: 40)) // displaying score (using font custom "Fuzzy Bubbles Regular" and size 40)
                    .font(.system(size: 40)) // change size of text to be bigger for score
                
                ScrollView { // for displaying emojis and cards
                    LazyVGrid(columns: columns) { // for rows and columns
                        ForEach(0..<emojis.count) { emoji in // going through emojis
                            ZStack{ // for cards ot cover emojis
                                Text(emojis[emoji]) // display emoji
                                    .font(.largeTitle) // change size of emoji
                                    .frame(height: 75) // spacing
                                Button(action: { // make card
                                    button[emoji].toggle() // if button clicked, disappear
                                    
                                    if pickOne == -1{ // if no emoji stored for first choice, store it
                                        pickOne = emoji
                                    }else{ // else store emoji in choice two
                                        pickTwo = emoji
                                        
                                        if emojis[pickOne] == emojis[pickTwo]{ // if choice 1 emoji is the same as choice 2 emoji, increase score by 1
                                            score += 1
                                        }
                                    }
                                    
                                    if pickOne != -1 && pickTwo != -1 && emojis[pickOne] != emojis[pickTwo]{ // if 3rd card clicked, hide cards
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                            button[pickOne].toggle() // hide card
                                            button[pickTwo].toggle() // hide card
                                            
                                            pickOne = -1 // reset choice 1
                                            pickTwo = -1 // reset choice 2
                                        }
                                    }else if pickOne != -1 && pickTwo != -1 && emojis[pickOne] == emojis[pickTwo]{ // if two cards picked matches, do not hide
                                        pickOne = -1 // reset choice 1
                                        pickTwo = -1 // reset choice 2
                                    }
                                }) {
                                    Text("") // for buttons to display nothing (like cards in example)
                                        .padding(.horizontal, 40) // make size of button bigger (horizontally)
                                        .padding(.vertical, 30) // make size of button bigger (vertical)
                                        .background(Color.blue) // make card blue
                                        .cornerRadius(8) // make card more round
                                        .opacity(button[emoji] ? 0 : 1) // to display card when not clicked AND make card disappeared when clicked
                                }
                            }
                        }
                    }
                    .padding(.horizontal) // increase horizontal length of area
                }
                .frame(maxHeight: 400) // to display emojis and cards all at once without scrolling
                
                HStack{ // to display next button and retry button side by side (if score is perfect / 6)
                    if score == 6   { // if score is perfect (6)
                        NavigationLink(destination: PerfectView()){ // to change views to finish
                            Text("Next") // button text to do so
                        }
                        .padding(.vertical, 15) // vertical length of button
                        .padding(.horizontal, 40) // horizontal length of button
                        .background(Color.blue) // change button to blue
                        .foregroundColor(.white) // change text of button blue
                        .cornerRadius(8) // make button more round
                        .font(.system(size: 30)) // make text of button bigger
                        
                        Button("Retry"){ // for user to retry game
                            emojis.shuffle() // shuffle the emojis (emojis not in same location)
                            button = [false, false, false, false, false, false, false, false, false, false, false, false] // status of cards flipped all set to not flipped
                            score = 0 // reset score
                        }
                        .padding(.vertical, 15) // vertical length of button
                        .padding(.horizontal, 40) // horizontal length of button
                        .background(Color.blue) // change button to blue
                        .foregroundColor(.white) // change text of button blue
                        .cornerRadius(8) // make button more round
                        .font(.system(size: 30)) // make text of button bigger
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true) // gets rid of back button
    }
}

struct PerfectView: View{ // to show finish view
    var body: some View{ // to show stuff for finish
        ZStack{ // for text, etc to be on top of finish background
            Image("game") // image for finish
                .resizable() // to be able to change size of image
                .aspectRatio(contentMode: .fill) // to use image on all the screen space
                .edgesIgnoringSafeArea(.all) // to use image on all the screen space
            
            VStack{ // to display emoji, text, and retry button on separate lines
                Text("😃") // for decorations (shows emoji)
                    .font(.system(size: 140)) // make emoji bigger
                Text("Great job!") // to congratulate on getting perfect score
                    .font(.system(size: 50)) // make text bigger
                NavigationLink(destination: CardGameView()){ // to change view to game if user wants to play again
                    Text("Play Again") // text on button so user knows it's the button to press to play again
                }
                .padding(.vertical, 25) // vertical length of button
                .padding(.horizontal, 50) // horiztonal length of button
                .background(Color.blue) // to make button blue
                .foregroundColor(.white) // to make text of button white
                .cornerRadius(8) // to make button more round
                .font(.system(size: 35)) // to make text of button biegger
            }
        }
        .navigationBarBackButtonHidden(true) // gets rid of back button
    }
}

#Preview {
    ContentView()
}

