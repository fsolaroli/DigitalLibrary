//
//  BookListView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 08/06/22.
//

import SwiftUI

struct BookListView: View {
    
    @ObservedObject var book: Book
    
    var body: some View {
        HStack {
            BookCoverView(book: book).frame(width: 100, height: 150)
            VStack(alignment: .leading) {
                Text((book.title ?? "") /*debug + " - " + String(book.index) debug*/).font(.title3).padding()
                Spacer()
                HStack {
                    Text("Autore: ").fontWeight(.bold)
                    Text(book.authors ?? "").lineLimit(1)
                }
                HStack {
                    Text("Casa editrice: ").fontWeight(.bold)
                    Text(book.editor ?? "").lineLimit(1)
                }
                HStack {
                    Text("Anno di pubblicazione: ").fontWeight(.bold)
                    Text(book.publishDate != 0 ? String(book.publishDate) : "").lineLimit(1)
                }
                HStack {
                    Text("Numero di pagine: ").fontWeight(.bold)
                    Text(book.pageCount != 0 ? String(book.pageCount) : "").lineLimit(1)
                }
                Spacer()
            }.font(.caption).padding(.horizontal, 10)
        }
    }
}
