//
//  AddShelf.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI

struct AddShelf: View {
    
    var viewModel: ManageData
    
    @ObservedObject var bookshelf: Bookshelf
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var name = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Nome", text: $name)
                }
                Button(action: {
                    viewModel.addShelf(name: name, bookshelf: bookshelf, viewContext: viewContext)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Aggiungi")
                }).disabled(name == "")
            }.navigationTitle("Nuovo Scaffale")
        }
    }
}
