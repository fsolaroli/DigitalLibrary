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
    @State var showFavourites = false
    
    @State var filter = ""
    
    @FetchRequest(
        entity: Book.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true)],
        animation: .default)
    private var books: FetchedResults<Book>
    @State private var filteredBooks: [Book] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Filtra libri", text: $filter, onEditingChanged: { changed in
                        if (!changed) {
                            withAnimation {
                                if (filter == "") {
                                    filteredBooks = Array(books)
                                } else {
                                    filteredBooks = filteredBooks.filter { $0.title!.contains(filter) }
                                }
                            }
                        }
                    }).textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                    Button(
                        action: {
                            withAnimation {
                                showFavourites.toggle()                                
                            }
                        },
                        label: {
                            if (showFavourites) {
                                Image(systemName: "heart.fill").foregroundColor(.red)
                            } else {
                                Image(systemName: "heart")
                            }
                        }
                    ).font(.title2)
                }.padding(.bottom, 1)
                Divider()
                ScrollView(.vertical) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 5) {
                        ForEach(showFavourites ? filteredBooks.filter { $0.favourite } : filteredBooks) { book in
                            NavigationLink(destination: BookView(viewModel: viewModel, book: book)) {
                                SmallBookView(book: book)
                            }
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
        .onAppear(perform: { filteredBooks = Array(books) })
    }
}
