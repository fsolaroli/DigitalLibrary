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
    
    @State private var isEditable = false
    @State var showAddBook = false
    @State var itemToRemove: Book? = nil
    
    var books: [Book] {
        get {
            var books:[Book] = []
            if let NSOrderedBooks = shelf.books {
                NSOrderedBooks.forEach({ s in books.append(s as! Book) })
            }
            return books.sorted(by: {s1, s2 in s1.index < s2.index})
        }
    }
    
    var body: some View {
        if (isEditable) {
            TextField("Nome scaffale", text: Binding<String>(
                get: { shelf.name! },
                set: {
                    shelf.name = $0
                    try? viewContext.save()
                }
            )).textFieldStyle(RoundedBorderTextFieldStyle()).font(.title).padding()
        }
        List {
            ForEach(books) { book in
                if (isEditable) {
                    HStack {
                        HStack {
                            if let coverData = book.cover, let coverImage = UIImage(data: coverData){
                                Image(uiImage: coverImage).resizable().scaledToFit()
                            } else {
                                Image(systemName: "book.closed").resizable().font(Font.title.weight(.ultraLight)).scaledToFit()
                            }
                        }.frame(width: 50, height: 50)
                        Text(book.title ?? "").lineLimit(2)
                    }
                } else {
                    NavigationLink(destination: BookView(viewModel: viewModel, book: book).environment(\.managedObjectContext, viewContext)) {
                        HStack {
                            SmallBookView(book: book).frame(width: 100, height: 150)
                            VStack(alignment: .leading) {
                                Text(book.title ?? "").font(.title3).padding()
                                Spacer()
                                HStack {
                                    Text("Autore: ").fontWeight(.bold)
                                    Text(book.authors ?? "")
                                }
                                HStack {
                                    Text("Casa editrice: ").fontWeight(.bold)
                                    Text(book.editor ?? "")
                                }
                                HStack {
                                    Text("Anno di pubblicazione: ").fontWeight(.bold)
                                    Text(book.publishDate != 0 ?  String(book.publishDate) : "")
                                }
                                HStack {
                                    Text("Numero di pagine: ").fontWeight(.bold)
                                    Text(book.pageCount != 0 ? String(book.pageCount) : "")
                                }
                                Spacer()
                            }.font(.caption).padding(.horizontal, 10)
                        }
                    }
                }
            }
            .onDelete(perform: { indexSet in
                itemToRemove = books[indexSet.first!]
                if let itemToRemove = itemToRemove {
                    viewModel.delete(itemToRemove, viewContext: viewContext)
                }
            })
            .onMove(perform: move)
        }
        .environment(\.editMode, .constant(isEditable ? .active : .inactive))
        .navigationTitle(isEditable ? "" : shelf.name ?? "Nome Libreria")
        .navigationBarTitleDisplayMode(isEditable ? .inline : .automatic)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if !isEditable {
                    Menu {
                        Button(
                            action: { if(isEditable) { try? viewContext.save() }; isEditable.toggle() },
                            label: { Image(systemName: "list.bullet"); Text("Modifica Scaffale") }
                        )
                        Button(
                            action: { showAddBook = true },
                            label: { Image(systemName: "plus"); Text("Aggiungi Libro") }
                        )
                    }
                    label: { Image(systemName: "ellipsis").imageScale(.large).frame(width: 40, height: 60) }
                } else {
                    Button(action: { isEditable.toggle() }, label: { Text("Fatto") })
                }
            }
        }
        .sheet(
            isPresented: $showAddBook, onDismiss: { viewModel.resetInputBook() },
            content: {
                AddBook(viewModel: viewModel, bookshelf: shelf.bookshelf!, shelf: shelf)
                    .environment(\.managedObjectContext, viewContext)
            }
        )
    }
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.move(books, from: source.first!, to: destination, viewContext: viewContext)
    }
}
