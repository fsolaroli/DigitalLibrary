//
//  BookLibraryListView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI

struct BookshelfListView: View {    
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isEditable = false
    @State var showAddBookshelf = false
    
    @State var showAlert = false;
    @State var itemToRemove: Bookshelf? = nil
      
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
                        Text(bookshelf.name!).font(.title2)
                    }
                }
                .onMove(perform: move)
                .onDelete(perform: { indexSet in
                    itemToRemove = bookshelfs[indexSet.first!]
                    if let itemToRemove = itemToRemove {
                        if (itemToRemove.shelfs == nil || itemToRemove.shelfs == []) {
                            viewModel.delete(itemToRemove, viewContext: viewContext)
                            self.itemToRemove = nil
                        } else {
                            showAlert = true
                        }
                    }
                })
            }
            .environment(\.editMode, .constant(isEditable ? .active : .inactive))
            .navigationTitle("Librerie")
            .listStyle(PlainListStyle())
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    if !isEditable {
                        Menu {
                            Button(
                                action: { isEditable.toggle() },
                                label: { Image(systemName: "list.bullet"); Text("Modifica Librerie") }
                            ).disabled(bookshelfs.isEmpty)
                            Button(
                                action: { showAddBookshelf = true },
                                label: { Image(systemName: "plus"); Text("Aggiungi Libreria") }
                            )
                        }
                        label: {
                            HStack {
                                Image(systemName: "ellipsis").imageScale(.large)
                            }.frame(width: 40, height: 60)
                        }
                    } else {
                        Button(action: { isEditable.toggle() }, label: { Text("Fatto") }).disabled(bookshelfs.isEmpty)
                    }
                }
            }
            .sheet(isPresented: $showAddBookshelf, content: {
                AddBookshelf(viewModel: viewModel, nextIndex: bookshelfs.count)
                    .environment(\.managedObjectContext, viewContext)
            })
            .alert(isPresented: $showAlert) { Alert(
                title: Text("Attenzione"),
                message: Text("Cancellando la libreria si cancelleranno anche gli scaffali e i libri al suo interno"),
                primaryButton: .destructive(Text("Annulla")) { self.itemToRemove = nil },
                secondaryButton: .destructive(Text("Continua")) {
                    if let itemToRemove = itemToRemove {
                        viewModel.delete(itemToRemove, viewContext: viewContext)
                        self.itemToRemove = nil
                    }
                }
            )}
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.move(Array(bookshelfs), from: source.first!, to: destination, viewContext: viewContext)
    }
}
