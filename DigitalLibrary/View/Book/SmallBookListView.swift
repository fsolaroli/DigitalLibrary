//
//  SmallerBookView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 06/06/22.
//

import SwiftUI

struct SmallBookListView: View {
    
    @State var book: Book
    
    var body: some View {
        HStack {
            HStack {
                if let coverData = book.cover, let coverImage = UIImage(data: coverData){
                    Image(uiImage: coverImage).resizable().scaledToFit()
                } else {
                    Image(systemName: "book.closed").resizable().font(Font.title.weight(.ultraLight)).scaledToFit()
                }
            }.frame(width: 50, height: 50)
            Text((book.title ?? "") /*debug + " - " + String(book.index) debug*/).lineLimit(2)
        }
    }
}

