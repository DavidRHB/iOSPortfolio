//
//  ContentView.swift
//  Bookworm
//
//  Created by David Hernandez on 31/08/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    //Model Context to use later, query to read book, and Boolean that tracks whether the add screen is showing or not.
    @Environment(\.modelContext) var modelContext
    @Query(sort: [
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.author)
    ]) var books: [Book] //You can sort your data with this
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                //Highlight the book in red if the rating is 1 star
                                Text(book.title)
                                    .font(.headline)
                                    .foregroundColor(book.rating == 1 ? .red : .primary)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book) //this links to DetailView()
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
                }
        }
    }
    func deleteBooks(at offsets: IndexSet) { //delete function
        for offset in offsets {
            //find this book in our query
            let book = books[offset]
            
            //delete it from the context
            modelContext.delete(book)
        }
    }
}

#Preview {
    ContentView()
}
