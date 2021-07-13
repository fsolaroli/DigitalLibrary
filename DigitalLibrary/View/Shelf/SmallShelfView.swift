//
//  ShelfView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI

struct SmallShelfView: View {
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var shelf: Shelf
    
    var books: [Book] {
        get {
            var books:[Book] = []
            if let NSOrderedBooks = shelf.books {
                NSOrderedBooks.forEach({ s in books.append(s as! Book) })                
            }
            return books.sorted(by: {s1, s2 in s1.index < s2.index})
        }
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: ShelfView(viewModel: viewModel, shelf: shelf).environment(\.managedObjectContext, viewContext)) {
                HStack {
                    Image(systemName: "square.split.2x2").foregroundColor(Color(UIColor.systemBlue)).imageScale(.medium)
                    Text(shelf.name ?? "Nome Scaffale").font(.title2)
                    Spacer()
                }
            }
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(books) { book in
                        NavigationLink(destination: BookView(viewModel: viewModel, book: book).environment(\.managedObjectContext, viewContext)) {
                            SmallBookView(book: book).frame(width: 150, height: 200)
                        }
                    }
                }
            }
        }
    }
}
