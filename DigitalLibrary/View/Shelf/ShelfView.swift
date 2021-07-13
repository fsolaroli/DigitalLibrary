//
//  ShelfView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 13/07/21.
//

import SwiftUI

struct ShelfView: View {
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isEditable = false
    
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
                                Image(systemName: "book.closed").resizable().scaledToFit()
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
                var itemsToRemove = [Book]()
                for indexToRemove in indexSet {
                    itemsToRemove.append((shelf.books?.object(at: indexToRemove)) as! Book)
                }

                viewModel.delete(itemsToRemove, viewContext: viewContext)
            })
            .onMove(perform: move)
        }
        .environment(\.editMode, .constant(isEditable ? .active : .inactive))
//        .frame(height: (65 * CGFloat(books.count)))
        .navigationTitle(isEditable ? "" : shelf.name ?? "Nome Libreria")
        .navigationBarTitleDisplayMode(isEditable ? .inline : .automatic)
        .navigationBarItems(
            leading: Button(
                action: {
                    if(isEditable) { try? viewContext.save() }
                    isEditable.toggle()
                },
                label: { Text(isEditable ? "Fatto" : "Modifica") }
            )
//            ,
//            trailing: Button(
//                action: {
//                    showAddShelfView = true
//                },
//                label: {
//                    Image(systemName: "plus").imageScale(.large)
//                }
//            )
        )
    }
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.move(books, from: source.first!, to: destination, viewContext: viewContext)
    }
}
