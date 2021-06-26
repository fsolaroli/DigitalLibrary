//
//  AllBookGridView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 25/06/21.
//

import SwiftUI

struct AllBookGridView: View {
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var showAddBook = false
    
    @FetchRequest(
        entity: Book.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true)],
        animation: .default)
    private var books: FetchedResults<Book>
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 5) {
                    ForEach(books) { book in
                        NavigationLink(destination: BookView(viewModel: viewModel, book: book)) {
                            SmallBookView(book: book)
                        }
                    }
                }
            }
            .navigationTitle("Libri")
            .navigationBarItems(trailing: Button(action: { showAddBook = true }, label: { Image(systemName: "plus.circle").imageScale(.large) }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(
            isPresented: $showAddBook, onDismiss: { viewModel.resetInputBook() },
            content: {
                AddBook(viewModel: viewModel)
                    .environment(\.managedObjectContext, viewContext)
            }
        )
    }
}
