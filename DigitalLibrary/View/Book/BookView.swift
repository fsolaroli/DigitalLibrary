//
//  BookView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI

struct BookView: View {
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var book: Book
    
    @State var showEditBook = false
    
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                Text("\(book.shelf?.bookshelf?.name ?? "Nome libreria") > \(book.shelf?.name ?? "Nome scaffale")").font(.footnote).foregroundColor(Color(UIColor.systemBlue))
                Spacer()
            }.padding(.top).padding(.horizontal
            )
            Text(book.title ?? "").font(.title).padding()
            Spacer()
            if let coverData = book.cover, let coverImage = UIImage(data: coverData){
                Image(uiImage: coverImage).resizable().scaledToFit().padding(.horizontal
                )
            }
            Divider()
            VStack(alignment: .leading) {
                HStack {
                    Text("Dati del libro").font(.title2).padding(.horizontal)
                    Spacer()
                }.padding(.bottom, 2)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Autore: ").font(.headline)
                        Text(book.authors ?? "")
                    }
                    HStack {
                        Text("Casa editrice: ").font(.headline)
                        Text(book.editor ?? "")
                    }
                    HStack {
                        Text("Anno di pubblicazione: ").font(.headline)
                        Text(book.publishDate != 0 ?  String(book.publishDate) : "")
                    }
                    HStack {
                        Text("Numero di pagine: ").font(.headline)
                        Text(book.pageCount != 0 ? String(book.pageCount) : "")
                    }
                }.padding(.horizontal, 30)
            }
            Divider()
            Button(
                action: {
                    viewModel.delete([book], viewContext: viewContext)
                    presentationMode.wrappedValue.dismiss()
                },
                label: {
                    HStack {
                        Image(systemName: "trash")
                            .renderingMode(.template)
                            .foregroundColor(Color.red)
                        
                        Text("Rimuovi Libro")
                            .foregroundColor(Color.red)
                    }
                    .font(.title2)
                    .foregroundColor(Color.red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .cornerRadius(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.red, lineWidth: 2)
                    )
                 }
            ).padding(40)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: { showEditBook = true }, label: { Text("Modifica") }))
        .sheet(isPresented: $showEditBook, onDismiss: { viewContext.rollback() }) {
            ModifyBook(viewModel: viewModel, book: book, bookshelf: book.shelf!.bookshelf!)
                .environment(\.managedObjectContext, viewContext)
        }
    }
}
