//
//  ShelfView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 13/07/21.
//

import SwiftUI

struct ShelfView: View {
    
    @ObservedObject var viewModel: ManageData
    @ObservedObject var shelf: Shelf
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showAlert = false
    @State private var isEditable = false
    @State private var showAddBook = false
    @State private var showMoveBooks = false
    
    var books: [Book] {
        get {
            var books:[Book] = []
            if let NSOrderedBooks = shelf.books {
                NSOrderedBooks.forEach({ b in books.append(b as! Book) })
            }
            return books.sorted(by: {b1, b2 in b1.index < b2.index})
        }
    }
    
    var body: some View {
     
        List {
            ForEach(books) { book in
                NavigationLink(destination: BookView(viewModel: viewModel, book: book).environment(\.managedObjectContext, viewContext)) {
                    BookListView(book: book)
                }
                .swipeActions(allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        viewModel.delete(book, from: books, viewContext: viewContext)
                        showAlert = true
                    } label: {
                        Label("Elimina", systemImage: "trash.fill")
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        book.favourite.toggle()
                        try? viewContext.save()
                    } label: {
                        Label("Preferito", systemImage: book.favourite ? "star.fill" : "star")
                    }.tint(.yellow)
                }
            }
            .onMove(perform: move)
        }
        .textFieldAlert(isPresented: $isEditable, title: "Modifica Scaffale", text: shelf.name!, accept: "Salva", action: { name in
            if name != nil && name != "" {
                shelf.name = name!
                try? viewContext.save()
            }
        })
        .alert("Attenzione", isPresented: $showAlert) {
            Button(role: .destructive) {
                try? viewContext.save()
            } label: {
                Text("Conferma")
            }
            Button("Annulla", role: .cancel) { viewContext.rollback() }
        } message: {
            Text("Il libro verrà eliminato")
        }
        .navigationTitle(shelf.name!)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    /*debug* Button(action: { viewModel.fix(books, viewContext: viewContext) }, label: { Text("FIX") }) *debug*/
                    Button(
                        action: { showAddBook = true },
                        label:  { Image(systemName: "plus"); Text("Aggiungi Libro") }
                    )
                    Button(
                        action: { showMoveBooks.toggle() },
                        label:  { Image(systemName: "checkmark.circle"); Text("Muovi libri") }
                    ).disabled(books.isEmpty)
                    Button(
                        action: { isEditable.toggle() },
                        label:  { Image(systemName: "square.and.pencil"); Text("Modifica Scaffale") }
                    )
                }
                label: { Image(systemName: "ellipsis").imageScale(.large).frame(width: 40, height: 60) }
            }
        }
        .sheet(
            isPresented: $showAddBook, onDismiss: { viewModel.resetInputBook() },
            content: {
                AddBook(viewModel: viewModel, bookshelf: shelf.bookshelf!, shelf: shelf)
                    .environment(\.managedObjectContext, viewContext)
            }
        )
        .sheet(
            isPresented: $showMoveBooks, onDismiss: { },
            content: {
                MoveBooks(viewModel: viewModel, bookshelf: shelf.bookshelf!, shelf: shelf, books: books)
                    .environment(\.managedObjectContext, viewContext)
            }
        )
    }
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.move(books, from: source.first!, to: destination, viewContext: viewContext)
    }
}
