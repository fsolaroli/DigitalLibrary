//
//  AllBookGridView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 25/06/21.
//

import SwiftUI

enum Orders {
    case ALPHABETIC
    case AUTHOR
    case DATE
    
    func group (_ b: Book) -> String {
        switch self {
            case .ALPHABETIC:
                return b.title?.first?.description ?? ""
            case .AUTHOR:
                return b.authors ?? ""
            case .DATE:
                return String(b.publishDate)
        }
    }
    
    func label () -> Label<Text, Image> {
        switch self {
            case .ALPHABETIC:
                return Label("Alfabetico", systemImage: "abc")
            case .AUTHOR:
                return Label("Autore", systemImage: "person")
            case .DATE:
                return Label("Pubblicazione", systemImage: "calendar")

        }
    }
}

struct AllBookGridView: View {
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext

    @State var showAddBook = false
    @State var showFavourites = false
    @State var filter = ""
    @State var order = Orders.ALPHABETIC
   
    @FetchRequest(
        entity: Book.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true)],
        animation: .default)
    private var books: FetchedResults<Book>
    
    private var groupedBooks: Dictionary<String, [Book]> {
        get {
            var toShow: [Book] = Array(books)
            if (showFavourites) {
                toShow = toShow.filter({$0.favourite})
            }
            if (filter != "") {
                toShow = toShow.filter {
                    $0.title!.searchFormat().contains(filter.searchFormat()) ||
                    $0.authors?.searchFormat().contains(filter.searchFormat()) ?? false ||
                    $0.editor?.searchFormat().contains(filter.searchFormat()) ?? false ||
                    (String($0.publishDate) == filter)
                }
            }
            return Dictionary(grouping: toShow, by: {order.group($0)})
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical) {
                    if (groupedBooks.isEmpty && !books.isEmpty) {
                        Text("Nessun libro corrisponde ai criteri della ricerca").padding(.top, 10)
                    }
                    withAnimation {
                        VStack {
                            ForEach(groupedBooks.sorted(by: { $0.0 < $1.0 }), id: \.key) {category, books in
                                withAnimation {
                                    VStack {
                                        HStack {
                                            Text(category).font(.title2)
                                        }
                                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                                            ForEach(books) { book in
                                                NavigationLink(destination: BookView(viewModel: viewModel, book: book)) {
                                                    BookCoverView(book: book)
                                                }
                                            }
                                        }
                                    }.padding(.bottom, 20)
                                }
                            }
                        }
                    }
                }
                // MARK: iOS16
                //.scrollDismissesKeyboard(.interactively)
            
            }
            
            .navigationTitle("Libri")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Menu(
                        content: {
                            Button(
                                action: { order = Orders.ALPHABETIC },
                                label: { Orders.ALPHABETIC.label() }
                            )
                            Button(
                                action: { order = Orders.AUTHOR },
                                label: { Orders.AUTHOR.label() }
                            )
                            Button(
                                action: { order = Orders.DATE },
                                label: { Orders.DATE.label() }
                            )
                        },
                        label: { order.label().imageScale(.large) }
                    )
                    Button(
                        action: { withAnimation { showFavourites.toggle() }},
                        label: {
                            if (showFavourites) {
                                Image(systemName: "star.fill").foregroundColor(.yellow).imageScale(.large)
                            } else {
                                Image(systemName: "star").imageScale(.large)
                            }
                        }
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddBook = true }, label: { Image(systemName: "plus").imageScale(.large) })
                }
                
            }
            .searchable(text: $filter, placement: .navigationBarDrawer(displayMode: .always), prompt: "Filtra libri")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(
            isPresented: $showAddBook, onDismiss: { viewModel.resetInputBook() },
            content: { AddBook(viewModel: viewModel).environment(\.managedObjectContext, viewContext) }
        )
    }
}
