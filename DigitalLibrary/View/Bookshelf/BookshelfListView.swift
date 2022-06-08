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
     
    @State var showAddBookshelf = false
    @State var showAlert = false;
    
    @FetchRequest(
        entity: Bookshelf.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Bookshelf.index, ascending: true)],
        animation: .default)
    private var bookshelfs: FetchedResults<Bookshelf>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(bookshelfs) { bookshelf in
                    NavigationLink(destination: BookshelfView(viewModel: viewModel, bookshelf: bookshelf).environment(\.managedObjectContext, viewContext)) {
                        HStack {
                            Text(bookshelf.name! /*debug* + " - " + String(bookshelf.index) *debug*/).font(.title2)
                            Spacer()
                            HStack {
                                Text(viewModel.numberOfBooks(in: bookshelf))
                                Image(systemName: "book")
                            }
                        }
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            viewModel.delete(bookshelf, from: Array(bookshelfs), viewContext: viewContext)
                            if (bookshelf.shelfs == nil || bookshelf.shelfs == []) {
                                try? viewContext.save()
                            } else {
                                showAlert = true
                            }
                    } label: {
                            Label("Elimina", systemImage: "trash.fill")
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
            .textFieldAlert(isPresented: $showAddBookshelf, title: "Nuova Libreria", accept: "Aggiungi", action: { name in
                if name != nil && name != "" {
                    _ = viewModel.addBookshelf(name: name!, index: bookshelfs.count, viewContext: viewContext)                    
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
                Text("Cancellando la libreria si cancelleranno anche gli scaffali e i libri al suo interno")
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.move(Array(bookshelfs), from: source.first!, to: destination, viewContext: viewContext)
    }
}
