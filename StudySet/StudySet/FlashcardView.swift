import SwiftUI

struct FlashcardView: View {
    @Binding var flashcards: [Flashcard] // Pass flashcards into the view
    @State private var currentCardIndex: Int = 0 // Track the index of the current flashcard
    @State private var isFlipped: Bool = false // Track whether the flashcard is flipped
    
    var body: some View {
        VStack {
            if flashcards.isEmpty {
                Text("No Flashcards Available")
                    .font(.title)
                    .foregroundColor(.gray)
            } else {
                // Flashcard display with flip animation
                ZStack {
                    // Front (Question)
                    if !isFlipped {
                        Text(flashcards[currentCardIndex].question)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                            .frame(width: 300, height: 400)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .onTapGesture {
                                withAnimation {
                                    isFlipped.toggle()
                                }
                            }
                    } else {
                        // Back (Answer)
                        Text(flashcards[currentCardIndex].answer)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .frame(width: 300, height: 400)
                            .background(Color.green)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .onTapGesture {
                                withAnimation {
                                    isFlipped.toggle()
                                }
                            }
                    }
                }
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0)) // Flip effect
                
                // Navigation buttons for scrolling through flashcards
                HStack {
                    Button(action: previousCard) {
                        Text("Previous")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                    Button(action: nextCard) {
                        Text("Next")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
    
    // Function to go to the previous flashcard
    private func previousCard() {
        if currentCardIndex > 0 {
            withAnimation {
                isFlipped = false // Reset flip when switching cards
                currentCardIndex -= 1
            }
        }
    }
    
    // Function to go to the next flashcard
    private func nextCard() {
        if currentCardIndex < flashcards.count - 1 {
            withAnimation {
                isFlipped = false // Reset flip when switching cards
                currentCardIndex += 1
            }
        }
    }
}