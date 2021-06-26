//
//  ShelfView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI

struct ShelfView: View {
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isEditable = false
    @State var showAddBook = false
    
    @State var shelfName = ""
    
    @ObservedObject var shelf: Shelf
    
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
        VStack {
            HStack {
                if (isEditable) {
                    TextField("Nome scaffale", text: Binding<String>(
                        get: { shelf.name! },
                        set: {
                            shelf.name = $0
                            try? viewContext.save()
                        }
                    )).textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text(shelf.name ?? "Nome Scaffale").font(.title2)
                }
                Spacer()
                Text(isEditable ? "Fatto" : "Modifica")
                .onTapGesture { isEditable.toggle() }
            }
            if isEditable {
                List {
                    ForEach(books) { book in
                        HStack {
                            HStack {
                                if let coverData = book.cover, let coverImage = UIImage(data: coverData){
                                    Image(uiImage: coverImage).resizable().scaledToFit()
                                } else {
                                    Image(systemName: "book.closed").resizable().scaledToFit()
                                }
                            }.frame(width: 50, height: 50)
                            Text(book.title ?? "").lineLimit(2
                            )
                        }
                    }
                    .onDelete(perform: { indexSet in
                        var itemsToRemove = [Book]()
                        for indexToRemove in indexSet {
                            itemsToRemove.append((shelf.books?.object(at: indexToRemove)) as! Book)
                        }
                        
                        viewModel.delete(itemsToRemove, viewContext: viewContext)
                    })
                    .onMove(perform: move)
                }
                .environment(\.editMode, .constant(.active))
                .frame(height: (65 * CGFloat(books.count)))
            } else {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(books) { book in
                            NavigationLink(destination: BookView(viewModel: viewModel, book: book)) {
                                SmallBookView(book: book).frame(width: 150, height: 200)
                            }
                        }
                    }
                }
            }
            HStack {
                Spacer()
                Image(systemName: "plus.circle").imageScale(.large)
                .onTapGesture {
                    showAddBook = true
                }
            }.padding(5)
        }
        .sheet(
            isPresented: $showAddBook, onDismiss: { viewModel.resetInputBook() }, 
            content: {
                AddBook(viewModel: viewModel, shelf: shelf)
                    .environment(\.managedObjectContext, viewContext)
            })
        }
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.move(books, from: source.first!, to: destination, viewContext: viewContext)
    }
}
