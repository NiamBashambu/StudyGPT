import SwiftUI
import CoreData

struct DeckListView: View {
    @FetchRequest(sortDescriptors: []) var decks: FetchedResults<Deck>
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingEditAlert = false
    @State private var deckToEdit: Deck?
    @State private var newName: String = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(decks) { deck in
                    NavigationLink(destination: QuizView(deck: deck)) {
                        Text(deck.name ?? "Unnamed Deck")
                            .onLongPressGesture {
                                // Set the deck to edit and show alert
                                deckToEdit = deck
                                newName = deck.name ?? ""
                                showingEditAlert = true
                            }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteDeck(deck: deck)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Flashcard Decks")
            .toolbar {
                Button(action: addDeck) {
                    Label("Add Deck", systemImage: "plus")
                }
            }
            .alert("Edit Deck Name", isPresented: $showingEditAlert) {
                TextField("New Name", text: $newName)
                Button("Save", action: updateDeck)
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    private func addDeck() {
        let newDeck = Deck(context: viewContext)
        newDeck.name = "New Deck"

        do {
            try viewContext.save()
        } catch {
            print("Failed to save deck: \(error)")
        }
    }

    private func deleteDeck(deck: Deck) {
        viewContext.delete(deck)

        do {
            try viewContext.save()
        } catch {
            print("Failed to delete deck: \(error)")
        }
    }

    private func updateDeck() {
        guard let deck = deckToEdit else { return }
        deck.name = newName

        do {
            try viewContext.save()
        } catch {
            print("Failed to update deck: \(error)")
        }
    }
}

struct DeckListView_Previews: PreviewProvider {
    static var previews: some View {
        DeckListView()
    }
}
