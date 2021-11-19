//
//  ShelfView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI

struct SmallShelfView: View {
    
    @ObservedObject var viewModel: ManageData
    @ObservedObject var shelf: Shelf
    
    @Environment(\.managedObjectContext) private var viewContext    
    
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
                    Image(systemName: "book")
                    Text(String(shelf.books?.count ?? 0))
                }
            }.padding(.top, 6)
            GeometryReader { fullView in
                ScrollView(.horizontal) {
                    LazyHStack {
//                        var widths = [CGFloat](repeating: 150, count: books.count)
                        ForEach(books) { book in
                            GeometryReader { geometry in
                                let frame = geometry.frame(in: CoordinateSpace.global)
//                                let angle: Double = -pow(Double(frame.midX) - (Double(fullView.size.width) / 2.0), Double(1.0/3.0)) * 12.0
                                let angle: Double = -(Double(frame.midX) - Double(fullView.size.width) / 2.0) / 5
//                                let _ = print(angle)
//                                let _ = (widths[i] = CGFloat(150 * cos(angle * .pi / 180)) + 1)
//                                let width = CGFloat(150 * cos(angle * Double.pi / 180))
//                                let _ = print(widths[i])
                                NavigationLink(destination: BookView(viewModel: viewModel, book: book).environment(\.managedObjectContext, viewContext)) {
                                    SmallBookView(book: book).frame(width: 150)
                                }
//                                .frame(width: width, height: 200)
                                .frame(height: 200)
                                .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0))
                            }
                            .frame(width: 140)
//                            .frame(width: 150)
//                            .frame(width: widths[i])
                        }
                    }
                    .padding(.horizontal, (fullView.size.width - 150) / 2)
                }
//                .edgesIgnoringSafeArea(.all)
//                .frame(height: 205)
                // TODO: se hai voglia, in futuro, fare il cover flow decentemente
            }.frame(height: (shelf.books?.count ?? 0) == 0 ? 0 : 210)
        }
    }
}
