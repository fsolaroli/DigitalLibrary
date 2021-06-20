//
//  BookLibraryListView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI

struct BookLibraryListView: View {
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var showAddBookshelf = false
    
    @FetchRequest(
        entity: Bookshelf.entity(),
        sortDescriptors: [],
        animation: .default)
    private var bookshelfs: FetchedResults<Bookshelf>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(bookshelfs) { bookshelf in
                    NavigationLink(destination: ShelfListView(viewModel: viewModel, bookshelf: bookshelf)) {
                        Text(bookshelf.name!)
                    }
                }.onDelete(perform: { indexSet in
                    var itemsToRemove = [Bookshelf]()
                    for indexToRemove in indexSet {
                        itemsToRemove.append(bookshelfs[indexToRemove])
                    }
                    viewModel.delete(itemsToRemove, viewContext: viewContext)
                })
            }.navigationTitle("Librerie")
            .listStyle(PlainListStyle())
            .navigationBarItems(trailing: Button(
                action: { showAddBookshelf = true },
                label: { Image(systemName: "plus.circle").imageScale(.large) }
            ))
            .sheet(isPresented: $showAddBookshelf, content: {
                AddBookshelf(viewModel: viewModel)
                    .environment(\.managedObjectContext, viewContext)
            })
        }
    }
}

struct BookLibraryListView_Previews: PreviewProvider {
    static var previews: some View {
        BookLibraryListView(viewModel: ManageData())
    }
}
