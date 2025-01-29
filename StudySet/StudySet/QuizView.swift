import SwiftUI

struct QuizView: View {
    @ObservedObject var deck: Deck
    @State private var currentCardIndex = 0
    @State private var showAnswer = false
    @State private var score = 0

    var body: some View {
        VStack {
            ProgressBar(progress: CGFloat(currentCardIndex) / CGFloat(deck.flashcards?.count ?? 1))

            if let flashcard = deck.flashcards?[currentCardIndex] as? Flashcard {
                FlashcardView(flashcard: flashcard, showAnswer: $showAnswer)
                    .padding()
            }

            HStack {
                Button("Incorrect") {
                    markAnswer(isCorrect: false)
                    nextCard()
                }
                .buttonStyle(AnswerButtonStyle(color: .red))

                Spacer()

                Button("Correct") {
                    markAnswer(isCorrect: true)
                    score += 1
                    nextCard()
                }
                .buttonStyle(AnswerButtonStyle(color: .green))
            }
            .padding()

            Spacer()
            Text("Score: \(score) / \(deck.flashcards?.count ?? 0)")
                .font(.title2)
                .padding()
        }
        .navigationTitle(deck.name ?? "Quiz")
    }

    private func nextCard() {
        if currentCardIndex < (deck.flashcards?.count ?? 1) - 1 {
            currentCardIndex += 1
            showAnswer = false
        } else {
            print("Quiz Complete")
        }
    }

    private func markAnswer(isCorrect: Bool) {
        let flashcard = deck.flashcards?[currentCardIndex] as? Flashcard
        flashcard?.isCorrect = isCorrect

        do {
            try flashcard?.managedObjectContext?.save()
        } catch {
            print("Failed to save answer status: \(error)")
        }
    }
}
