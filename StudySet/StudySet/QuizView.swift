
import SwiftUI
struct QuizView: View {
    @ObservedObject var deck: Deck
    @State private var currentCardIndex = 0
    @State private var score = 0
    @State private var showingAddFlashcard = false
    @State private var quizComplete = false
    @State private var dragAmount: CGSize = .zero
    @State private var flipped: Bool = false
    @State private var showingFlashcardList = false

    @FetchRequest var flashcards: FetchedResults<Flashcard>
    @State private var incorrectCards: [Flashcard] = []
    @State private var isReviewingIncorrect = false

    init(deck: Deck) {
        _flashcards = FetchRequest(
            entity: Flashcard.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "deck == %@", deck)
        )
        self.deck = deck
    }

    var body: some View {
        NavigationView {
            VStack {
                if quizComplete {
                    completionView
                } else if flashcards.isEmpty {
                    Text("No flashcards available.")
                        .font(.title)
                        .padding()
                } else {
                    ProgressBar(progress: progressValue)
                        .padding(.top)

                    ZStack {
                        backgroundForSwipe()
                        flashcardSwipeView
                    }
                    .frame(maxHeight: .infinity)
                }

                // Always show the buttons
                HStack {
                    addButton
                    viewFlashcardListButton
                }
                .padding()
            }
            .navigationTitle(deck.name ?? "Quiz")
        }
    }

    // MARK: - Views

    private var flashcardSwipeView: some View {
        let flashcard = getCurrentCard()

        return FlashcardBoxView(flashcard: flashcard, flipped: $flipped)
            .offset(dragAmount)
            .rotationEffect(.degrees(Double(dragAmount.width / 10)))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragAmount = value.translation
                    }
                    .onEnded { value in
                        handleSwipe(value.translation.width)
                        dragAmount = .zero
                    }
            )
            .onTapGesture {
                withAnimation(.easeInOut) {
                    flipped.toggle()
                }
            }
            .padding()
    }

    private var completionView: some View {
        VStack {
            Text("Quiz Complete!")
                .font(.largeTitle)
                .padding()

            Text("Your Score: \(score) / \(flashcards.count)")
                .font(.title2)
                .padding()

            Button("Restart Quiz") {
                restartQuiz()
            }
            .font(.headline)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }

    private var addButton: some View {
        Button(action: {
            showingAddFlashcard = true
        }) {
            Text("Add Flashcard")
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .sheet(isPresented: $showingAddFlashcard) {
            AddFlashcardView(deck: deck)
        }
    }

    private var viewFlashcardListButton: some View {
        Button(action: {
            showingFlashcardList = true
        }) {
            Text("View Flashcards")
                .font(.headline)
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
        .sheet(isPresented: $showingFlashcardList) {
            FlashcardListView(flashcards: flashcards)
        }
    }

    // MARK: - Logic

    private func backgroundForSwipe() -> some View {
        Rectangle()
            .foregroundColor(dragAmount.width > 0 ? .green : .red)
            .opacity(abs(dragAmount.width) > 50 ? 0.5 : 0)
            .animation(.easeInOut, value: dragAmount)
    }

    private func handleSwipe(_ width: CGFloat) {
        if width > 100 {
            markAnswer(isCorrect: true)
            score += 1
            nextCard()
        } else if width < -100 {
            markAnswer(isCorrect: false)
            addIncorrectCard()
            nextCard()
        }
    }

    private func nextCard() {
        if isReviewingIncorrect {
            reviewNextIncorrectCard()
        } else if currentCardIndex < flashcards.count - 1 {
            currentCardIndex += 1
            flipped = false
        } else if !incorrectCards.isEmpty {
            isReviewingIncorrect = true
            currentCardIndex = 0
        } else {
            quizComplete = true
        }
    }

    private func getCurrentCard() -> Flashcard {
        isReviewingIncorrect ? incorrectCards[currentCardIndex] : flashcards[currentCardIndex]
    }

    private func reviewNextIncorrectCard() {
        if currentCardIndex < incorrectCards.count - 1 {
            currentCardIndex += 1
        } else {
            incorrectCards.removeAll()
            isReviewingIncorrect = false
            quizComplete = true
        }
        flipped = false
    }

    private func restartQuiz() {
        currentCardIndex = 0
        score = 0
        incorrectCards = []
        quizComplete = false
        flipped = false
        isReviewingIncorrect = false
    }

    private func markAnswer(isCorrect: Bool) {
        let flashcard = getCurrentCard()
        flashcard.isCorrect = isCorrect

        do {
            try flashcard.managedObjectContext?.save()
        } catch {
            print("Failed to save answer status: \(error)")
        }
    }

    private func addIncorrectCard() {
        let flashcard = flashcards[currentCardIndex]
        if !incorrectCards.contains(flashcard) {
            incorrectCards.append(flashcard)
        }
    }

    private var progressValue: CGFloat {
        let totalCards = flashcards.count + incorrectCards.count
        let answeredCards = score + incorrectCards.filter { $0.isCorrect }.count
        return CGFloat(answeredCards) / CGFloat(totalCards)
    }
}

struct FlashcardListView: View {
    var flashcards: FetchedResults<Flashcard>

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                // Section Titles
                HStack {
                    Text("Question")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Answer")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                .padding(.top)

                Divider() // Separates section titles from content

                // Flashcards List
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(flashcards, id: \.self) { flashcard in
                            FlashcardRow(flashcard: flashcard)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Flashcards")
            .navigationBarItems(trailing: Button("Done") {
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
}

struct FlashcardRow: View {
    var flashcard: Flashcard

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(flashcard.question ?? "No question")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading) {
                Text(flashcard.answer ?? "No answer")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

struct FlashcardBoxView: View {
    var flashcard: Flashcard
    @Binding var flipped: Bool

    var body: some View {
        ZStack {
            if flipped {
                backView
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            } else {
                frontView
            }
        }
        .frame(height: 300)
        .shadow(radius: 10)
        .rotation3DEffect(
            .degrees(flipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut, value: flipped)
    }

    private var frontView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.yellow)
            .overlay(
                Text(flashcard.question ?? "No question")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
            )
    }

    private var backView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.green)
            .overlay(
                Text(flashcard.answer ?? "No answer")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            )
    }
}


struct AddFlashcardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var deck: Deck

    @State private var question: String = ""
    @State private var answer: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Flashcard Details")) {
                    TextField("Question", text: $question)
                    TextField("Answer", text: $answer)
                }

                Button(action: addFlashcard) {
                    Text("Save Flashcard")
                }
            }
            .navigationTitle("New Flashcard")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func addFlashcard() {
        let newFlashcard = Flashcard(context: viewContext)
        newFlashcard.question = question
        newFlashcard.answer = answer
        newFlashcard.isCorrect = false
        newFlashcard.deck = deck

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to save flashcard: \(error)")
        }
    }
}
