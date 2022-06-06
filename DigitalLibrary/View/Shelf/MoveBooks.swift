//
//  MoveBooks.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 04/06/22.
//

import SwiftUI

struct MoveBooks: View {
        
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentationMode

    
    var viewModel: ManageData
    
    @State var bookshelf: Bookshelf
    @State var shelf: Shelf
    
    var books: [Book]
    
    @State var selectedBooks = Set<Book>()
    
    var initialShelf: Shelf? {
        return books.first?.shelf!
    }
    
    @FetchRequest(
        entity: Bookshelf.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Bookshelf.index, ascending: true)],
        animation: .default)
    private var bookshelfs: FetchedResults<Bookshelf>
    
    var shelfs: [Shelf] {
        get {
            var shelfs:[Shelf] = []
            bookshelf.shelfs!.forEach({ s in shelfs.append(s as! Shelf)})
            return shelfs.sorted(by: {s1, s2 in s1.index < s2.index})
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Posizione"), content: {
                        Picker(selection: $bookshelf, label: Text("Libreria"), content: {
                            ForEach(Array(bookshelfs)) { bookshelf in
                                Text(bookshelf.name!).tag(bookshelf)
                            }
                        })
                        Picker(selection: $shelf, label: Text("Scaffale"), content: {
                            ForEach(shelfs) { shelf in
                                Text(shelf.name!).tag(shelf)
                            }
                        })
                    })
                }
                .padding(.top, -24.0)
                .frame(height: 120.0)
                
                List(selection: $selectedBooks) {
                    ForEach(books, id: \.self) { book in
                        SmallerBookView(book: book)
                    }
                    .onDelete(perform: {indexSet in })
                }
                .environment(\.editMode, .constant(.active))
                
            }
            .navigationTitle("Muovi libri")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: { presentationMode.wrappedValue.dismiss() }, label: { Text("Annulla") }),
                trailing: Button(
                    action: {
                        viewModel.move(selectedBooks, from: books, to: shelf, viewContext: viewContext)
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: { Text("Muovi") }
                ).disabled(shelf.bookshelf! != bookshelf || shelf == initialShelf || selectedBooks.isEmpty)
            )
        }
    }
}

