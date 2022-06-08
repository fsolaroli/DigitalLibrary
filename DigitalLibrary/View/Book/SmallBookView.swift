//
//  SmallBookView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 26/06/21.
//

import SwiftUI

struct SmallBookView: View {
    
    @ObservedObject var book: Book
    
    var body: some View {
        ZStack {
            VStack {
                if let coverData = book.cover, let coverImage = UIImage(data: coverData){
                    Image(uiImage: coverImage).resizable().scaledToFit()
                } else {
                    Image(systemName: "book.closed").resizable().scaledToFit().opacity(0.5).font(Font.title.weight(.ultraLight)).foregroundColor(Color.gray)
                    .overlay(
                        VStack {
                            Text(book.title ?? "").font(.title2).padding(20)
                            Text(book.authors ?? "").font(.subheadline)
                            Spacer()
                        }.foregroundColor(Color(UIColor.label)).lineLimit(1)
                    )
                    if (book.borrowed != nil) {
                        Spacer()
                    }
                }
            }.opacity(book.borrowed != nil ? 0.4 : 1)
            if (book.favourite) {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "star.fill")
                            .overlay(Image(systemName: "star").foregroundColor(Color(UIColor.black)).font(.title))
                            .foregroundColor(Color(UIColor.yellow)).padding(.horizontal, 5).padding(.top, 5).font(.title2)
                    }
                    Spacer()
                }
            }
            if (book.borrowed != nil) {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "person.fill")
                            .overlay(Image(systemName: "person").foregroundColor(Color(UIColor.label)).font(.title))
                            .foregroundColor(Color(UIColor.systemBackground)).padding(.horizontal, 3).padding(.bottom, 3).font(.title)
                        Spacer()
                        BorrowedView(borrowed: book.borrowed!)
                        Spacer()
                        Spacer()
                    }
                }
            }
        }
    }
}

struct BorrowedView: View {
    
    @ObservedObject var borrowed: Borrowed
    
    var body: some View {
        Text(borrowed.person ?? "").foregroundColor(Color(UIColor.label)).lineLimit(1).font(.subheadline)
    }
}
