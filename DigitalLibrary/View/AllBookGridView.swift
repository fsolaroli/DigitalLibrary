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
    private var filteredBooks: [Book] {
        get {
            if (filter == "") {
                return Array(books)
            } else {
                return books.filter {
                    $0.title!.searchFormat().contains(filter.searchFormat()) ||
                    $0.authors?.searchFormat().contains(filter.searchFormat()) ?? false ||
                    $0.editor?.searchFormat().contains(filter.searchFormat()) ?? false
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ZStack {
                        TextField("Filtra libri", text: Binding(get: { filter }, set: { newValue in withAnimation { filter = newValue } }))
                            .textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal, 3)
                        HStack {
                            Spacer()
                            Button(action: { withAnimation { filter = "" }}, label: { Image(systemName: "xmark.circle") }).padding(.horizontal, 5).foregroundColor(Color(UIColor.label))
                        }
                    }
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
                }.padding(.bottom, 1).padding(.horizontal, 5)
                Divider()
                ScrollView(.vertical) {
                    if (filteredBooks.isEmpty && !books.isEmpty) {
                        Text("Nessun libro corrisponde ai criteri della ricerca")
                    }
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(showFavourites ? filteredBooks.filter { $0.favourite } : filteredBooks) { book in
                            NavigationLink(destination: BookView(viewModel: viewModel, book: book)) {
                                SmallBookView(book: book)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Libri")
            .navigationBarItems(trailing: Button(action: { showAddBook = true }, label: { Image(systemName: "plus").imageScale(.large) }))
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
