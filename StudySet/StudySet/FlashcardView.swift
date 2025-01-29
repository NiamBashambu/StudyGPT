import SwiftUI
import CoreData

struct FlashcardView: View {
    let flashcard: Flashcard
    @Binding var showAnswer: Bool

    var body: some View {
        ZStack {
            if showAnswer {
                Text(flashcard.answer ?? "No Answer")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            } else {
                Text(flashcard.question ?? "No Question")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .onTapGesture {
            withAnimation {
                showAnswer.toggle()
            }
        }
    }
}
