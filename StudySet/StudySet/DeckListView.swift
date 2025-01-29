//
//  DeskListView.swift
//  StudySet
//
//  Created by Niam Bashambu on 10/17/24.
//

import SwiftUI
import CoreData

struct DeckListView: View {
    @FetchRequest(sortDescriptors: []) var decks: FetchedResults<Deck>
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            List {
                ForEach(decks) { deck in
                    NavigationLink(destination: QuizView(deck: deck)) {
                        Text(deck.name ?? "Unnamed Deck")
                    }
                }
            }
            .navigationTitle("Flashcard Decks")
            .toolbar {
                Button(action: addDeck) {
                    Label("Add Deck", systemImage: "plus")
                }
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
}
struct DeskListView_Previews: PreviewProvider {
    static var previews: some View {
        DeskListView()
    }
}
