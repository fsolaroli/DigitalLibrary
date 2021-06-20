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
    
    @State var showAddBook = false
    
    @ObservedObject var shelf: Shelf
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(shelf.name ?? "").font(.title2)
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(Array(shelf.books?.set ?? Set<AnyHashable>()),id: \.self) { e in
                        let book = e as! Book
                        NavigationLink(destination: BookView(viewModel: viewModel, book: book)) {
                            Text(book.title!)
                        }
                    }
                }
            }
            HStack {
                Spacer()
                Button(
                    action: { showAddBook = true },
                    label: { Image(systemName: "plus.circle").imageScale(.large) }
                )
            }
        }.sheet(
            isPresented: $showAddBook,
            content: {
                AddBook(viewModel: viewModel, shelf: shelf)
                    .environment(\.managedObjectContext, viewContext)
            })
    }
}
