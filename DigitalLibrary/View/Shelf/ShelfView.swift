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
//    @State private var itemToRemove: Book? = nil

    @State private var bookshelfToMove: Bookshelf? = nil
    @State private var shelfToMove: Shelf? = nil
    
    @FetchRequest(
        entity: Bookshelf.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Bookshelf.index, ascending: true)],
        animation: .default)
    private var bookshelfs: FetchedResults<Bookshelf>
    
    var shelfs: [Shelf] {
        get {
            var shelfs:[Shelf] = []
            bookshelfToMove?.shelfs!.forEach({ s in shelfs.append(s as! Shelf)})
            return shelfs.sorted(by: {s1, s2 in s1.index < s2.index})
        }
    }
    
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
//        if (isEditable) {
//            TextField("Nome scaffale", text: Binding<String>(
//                get: { shelf.name! },
//                set: {
//                    shelf.name = $0
//                    try? viewContext.save()
//                }
//            )).textFieldStyle(RoundedBorderTextFieldStyle()).font(.title).padding()
//            Form {
//                Picker(selection: Binding<Bookshelf>(
//                    get: { shelf.bookshelf! },
//                    set: {
//                        if ($0 != shelf.bookshelf) {
//                            shelf.index = Int64($0.shelfs?.count ?? 0)
//                        }
//                        shelf.bookshelf = $0
//                        try? viewContext.save()
//                    }
//                ), label: Text("Scaffale"), content: {
//                    ForEach(Array(bookshelfs)) { bookshelf in
//                        Text(bookshelf.name!).tag(bookshelf)
//                    }
//                })
//            }
//            .padding(.top, -24.0)
//            .frame(height: 55.0)
//
//        }
        
        List {
            ForEach(books) { book in
//                if (isEditable) {
//                    SmallerBookView(book: book)
//                } else {
                    NavigationLink(destination: BookView(viewModel: viewModel, book: book).environment(\.managedObjectContext, viewContext)) {
                        HStack {
                            SmallBookView(book: book).frame(width: 100, height: 150)
                            VStack(alignment: .leading) {
                                Text((book.title ?? "") /*debug + " - " + String(book.index) debug*/).font(.title3).padding()
                                Spacer()
                                HStack {
                                    Text("Autore: ").fontWeight(.bold)
                                    Text(book.authors ?? "").lineLimit(1)
                                }
                                HStack {
                                    Text("Casa editrice: ").fontWeight(.bold)
                                    Text(book.editor ?? "").lineLimit(1)
                                }
                                HStack {
                                    Text("Anno di pubblicazione: ").fontWeight(.bold)
                                    Text(book.publishDate != 0 ? String(book.publishDate) : "").lineLimit(1)
                                }
                                HStack {
                                    Text("Numero di pagine: ").fontWeight(.bold)
                                    Text(book.pageCount != 0 ? String(book.pageCount) : "").lineLimit(1)
                                }
                                Spacer()
                            }.font(.caption).padding(.horizontal, 10)
                        }
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
//                }
            }
//            .onDelete(perform: { indexSet in
//                itemToRemove = books[indexSet.first!]
//                if let itemToRemove = itemToRemove {
//                    viewModel.delete(itemToRemove, from: books, viewContext: viewContext)
//                }
//            })
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
//        .environment(\.editMode, .constant(isEditable ? .active : .inactive))
        .navigationTitle(shelf.name!)
//        .navigationBarTitleDisplayMode(isEditable ? .inline : .automatic)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
//                if (!isEditable) {
                    Menu {
                        /*debug Button(action: { viewModel.fix(books, viewContext: viewContext) }, label: { Text("FIX") }) debug*/
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
//                } else {
//                    Button(action: { isEditable.toggle() }, label: { Text("Fatto") })
//                }
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
