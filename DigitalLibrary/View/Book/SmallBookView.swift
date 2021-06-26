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
            }.opacity(book.borrowed != nil ? 0.4 : 1)
            if (book.favourite) {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "heart.fill")
                            .overlay(Image(systemName: "heart").foregroundColor(Color(UIColor.label)).font(.title2))
                            .foregroundColor(Color(UIColor.red)).padding(.horizontal).padding(.top, 3).font(.title2)
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
                    }
                }
            }
        }
    }
}
