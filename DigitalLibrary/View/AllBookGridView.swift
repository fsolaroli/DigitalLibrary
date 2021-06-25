//
//  AllBookGridView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 25/06/21.
//

import SwiftUI

struct AllBookGridView: View {
    
    @ObservedObject var viewModel: ManageData
    
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
                            ZStack {
                                if let coverData = book.cover, let coverImage = UIImage(data: coverData){
                                    Image(uiImage: coverImage).resizable().scaledToFit()
                                } else {
                                    Image(systemName: "book.closed").resizable().scaledToFit().opacity(0.5)
                                    VStack {
                                        Text(book.title ?? "").font(.title).foregroundColor(Color(UIColor.label)).padding(20)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
            }.navigationTitle("Libri")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
