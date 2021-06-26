//
//  AddShelf.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI

struct AddShelf: View {
    
    var viewModel: ManageData
    var nextIndex: Int
        
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
            }
            .navigationTitle("Nuovo Scaffale")
            .navigationBarItems(
                leading: Button(action: { presentationMode.wrappedValue.dismiss() }, label: { Text("Annulla") }),
                trailing: Button(
                    action: {
                        viewModel.addShelf(name: name, index: nextIndex, bookshelf: bookshelf, viewContext: viewContext)
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: { Text("Aggiungi") }
                )
                .disabled(name == "")
            )
        }
    }
}
