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
    
//    @State private var isEditable = false
    @State var showAddBook = false
    
    @ObservedObject var shelf: Shelf
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(shelf.name ?? "").font(.title2)
//            if isEditable {
//                List {
//
//                }
                //                .environment(\.editMode, .constant(.active))

//            } else {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(Array(shelf.books?.set ?? Set<AnyHashable>()),id: \.self) { e in
                            let book = e as! Book
                            NavigationLink(destination: BookView(viewModel: viewModel, book: book)) {
                                ZStack {
                                    if let coverData = book.cover, let coverImage = UIImage(data: coverData){
                                        Image(uiImage: coverImage).resizable().scaledToFit()
                                    } else {
                                        Text(book.title ?? "").font(.title
                                        )
                                        Image(systemName: "photo").resizable().scaledToFit().opacity(0.5)
                                    }
                                }.frame(width: 150, height: 200)
                            }
                        }
                        
                    }
                }
//            }
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
    
//    func move(from source: IndexSet, to destination: Int) {
//        fruits.move(fromOffsets: source, toOffset: destination)
//        withAnimation {
//            isEditable = false
//        }
//    }
}
