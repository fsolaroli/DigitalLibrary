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
    
    var body: some View {
        VStack {
            Text("Questo Libro")
            Button(
                action: {
                    viewModel.delete([book], viewContext: viewContext)
                    presentationMode.wrappedValue.dismiss()
                },
                label: { Image(systemName: "trash").imageScale(.large) })
        }.navigationTitle(book.title ?? "")
    }
}
