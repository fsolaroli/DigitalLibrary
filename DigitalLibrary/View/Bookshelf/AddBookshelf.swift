//
//  AddBookshelf.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI

struct AddBookshelf: View {
    
    var viewModel: ManageData
    var nextIndex: Int
    
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
                    viewModel.addBookshelf(name: name, index: nextIndex, viewContext: viewContext)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Aggiungi")
                }).disabled(name == "")
            }.navigationTitle("Nuova Libreria")
        }
    }
}
