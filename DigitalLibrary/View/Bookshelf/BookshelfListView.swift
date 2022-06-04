//
//  BookLibraryListView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct BookshelfListView: View {    
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
     
    @State var showAddBookshelf = false
    @State var showAlert = false;
    @State var itemToRemove: Bookshelf? = nil
      
    @State var draggedItem : Bookshelf?
    
    @FetchRequest(
        entity: Bookshelf.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Bookshelf.index, ascending: true)],
        animation: .default)
    private var bookshelfs: FetchedResults<Bookshelf>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(bookshelfs) { bookshelf in
                    NavigationLink(destination: ShelfListView(viewModel: viewModel, bookshelf: bookshelf).environment(\.managedObjectContext, viewContext)) {
                        HStack {
                            Text(bookshelf.name! /*debug + " - " + String(bookshelf.index) debug*/).font(.title2)
                            Spacer()
                            HStack {
                                Image(systemName: "book")
                                Text(viewModel.numberOfBooks(in: bookshelf))
                            }
                        }
                    }
                    .onDrag({
                        self.draggedItem = bookshelf
                        return NSItemProvider(item: nil, typeIdentifier: bookshelf.name ?? "")
                    })
                    .onDrop(of: [UTType.text], delegate:
                        MyDropDelegate<Bookshelf>(item: bookshelf, items:
                            Binding<[Bookshelf]> (
                                get: { return Array(bookshelfs) },
                                set: { _ in }
                            )
                            , draggedItem: $draggedItem
                        )
                    )
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            if (bookshelf.shelfs == nil || bookshelf.shelfs == []) {
                                    viewModel.delete(bookshelf, from: Array(bookshelfs), viewContext: viewContext)
                                } else {
                                    self.itemToRemove = bookshelf
                                    showAlert = true
                                }
                    } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }
                .onMove(perform: move)
            }
            .navigationTitle("Librerie")
            .listStyle(PlainListStyle())
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(
                        action: { showAddBookshelf = true },
                        label: { Image(systemName: "plus") }
                    )
                }
            }
            .sheet(isPresented: $showAddBookshelf, content: {
                AddBookshelf(viewModel: viewModel, nextIndex: bookshelfs.count).environment(\.managedObjectContext, viewContext)
            })
            .alert("Attenzione", isPresented: $showAlert) {
                Button(role: .destructive) {
                    if let itemToRemove = itemToRemove {
                        viewModel.delete(itemToRemove, from: Array(bookshelfs), viewContext: viewContext)
                        self.itemToRemove = nil
                    }
                } label: {
                    Text("Conferma")
                }
                Button("Annulla", role: .cancel) { self.itemToRemove = nil }
            } message: {
                Text("Cancellando la libreria si cancelleranno anche gli scaffali e i libri al suo interno")
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.move(Array(bookshelfs), from: source.first!, to: destination, viewContext: viewContext)
    }
}
