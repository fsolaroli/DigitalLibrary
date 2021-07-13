//
//  ShelfListView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI

struct ShelfListView: View {
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isEditable = false
    @State var showAddShelfView = false
    
    @State var showAlert = false;
    @State var itemToRemove: Shelf? = nil
    
    @ObservedObject var bookshelf: Bookshelf
    
    var shelfs: [Shelf] {
        get {
            var shelfs:[Shelf] = []
            if let NSOrderedShelfs = bookshelf.shelfs {
                NSOrderedShelfs.forEach({ s in shelfs.append(s as! Shelf)})
            }
            return shelfs.sorted(by: {s1, s2 in s1.index < s2.index})
        }
    }
    
    var body: some View {
        if (isEditable) {
            TextField("Nome libreria", text: Binding<String>(
                get: { bookshelf.name! },
                set: {
                    bookshelf.name = $0;
                    try? viewContext.save()
                }
            )).textFieldStyle(RoundedBorderTextFieldStyle()).font(.title).padding()
        }
        List {
            ForEach(shelfs) { shelf in
                if isEditable {
                    Text(shelf.name ?? "").font(.title2)
                } else {
                    SmallShelfView(viewModel: viewModel, shelf: shelf)
                }
            }
            .onDelete(perform: { indexSet in
                itemToRemove = shelfs[indexSet.first!]
                if let itemToRemove = itemToRemove {
                    if (itemToRemove.books == nil || itemToRemove.books == []) {
                        viewModel.delete(itemToRemove, viewContext: viewContext)
                        self.itemToRemove = nil
                    } else {
                        showAlert = true
                    }
                }
            })
            .onMove(perform: move)
        }
        .alert(isPresented: $showAlert) { Alert(
            title: Text("Attenzione"),
            message: Text("Cancellando lo scaffale si cancelleranno i libri al suo interno"),
            primaryButton: .destructive(Text("Annulla")) { self.itemToRemove = nil },
            secondaryButton: .destructive(Text("Continua")) {
                if let itemToRemove = itemToRemove {
                    viewModel.delete(itemToRemove, viewContext: viewContext)
                    self.itemToRemove = nil
                }
            }
        )}
        .environment(\.editMode, .constant(isEditable ? .active : .inactive))
        .navigationTitle(isEditable ? "" : bookshelf.name ?? "Nome Libreria")
        .navigationBarTitleDisplayMode(isEditable ? .inline : .automatic)
        .listStyle(PlainListStyle())
        .navigationBarItems(
            leading: Button(
                action: {
                    if(isEditable) { try? viewContext.save() }
                    isEditable.toggle()
                },
                label: { Text(isEditable ? "Fatto" : "Modifica") }
            ),
            trailing: Button(
                action: {
                    showAddShelfView = true
                },
                label: {
                    Image(systemName: "plus").imageScale(.large)
                }
            )
        )
        .sheet(isPresented: $showAddShelfView, content: {
            AddShelf(viewModel: viewModel, nextIndex:bookshelf.shelfs?.count ?? 0, bookshelf: bookshelf)
                .environment(\.managedObjectContext, viewContext)
        })
    }
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.move(shelfs, from: source.first!, to: destination, viewContext: viewContext)
    }
}
