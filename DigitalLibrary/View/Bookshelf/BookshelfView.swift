//
//  ShelfListView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI

struct BookshelfView: View {
    
    @ObservedObject var viewModel: ManageData
    @ObservedObject var bookshelf: Bookshelf
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isEditable = false
    @State var showAddShelfView = false
    @State var showAlert = false;

    @FetchRequest(
        entity: Shelf.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Shelf.index, ascending: true)],
        animation: .default)
    private var fetchedShelfs: FetchedResults<Shelf>
    
    var shelfs: [Shelf] {
        get {
            var shelfs:[Shelf] = []
            if let NSOrderedShelfs = bookshelf.shelfs {
                NSOrderedShelfs.forEach({ s in shelfs.append(s as! Shelf) })
            }
            return shelfs.sorted(by: {s1, s2 in s1.index < s2.index})
        }
    }
    
    var body: some View {
        List {
            ForEach(shelfs) { shelf in
                SmallShelfView(viewModel: viewModel, shelf: shelf)
                .accessibilityIdentifier(shelf.name ?? "shelf")
                .swipeActions(allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        viewModel.delete(shelf, from: shelfs, viewContext: viewContext)
                        if (shelf.books == nil || shelf.books == []) {
                            try? viewContext.save()
                        } else {
                            showAlert = true
                        }
                } label: {
                        Label("Elimina", systemImage: "trash.fill")
                    }
                }
            }
            .onMove(perform: move)
        }
        .accessibilityIdentifier("shelfsList")
        .textFieldAlert(isPresented: $showAddShelfView, title: "Nuovo Scaffale", accept: "Aggiungi", action: { name in
            if name != nil && name != "" {
                viewModel.addShelf(name: name!, index: bookshelf.shelfs?.count ?? 0, bookshelf: bookshelf, viewContext: viewContext)
            }
        })
        .textFieldAlert(isPresented: $isEditable, title: "Modifica Libreria", text: bookshelf.name ?? "", accept: "Salva", action: { name in
            if name != nil && name != "" {
                bookshelf.name = name!
                try? viewContext.save()
            }
        })
        .alert("Attenzione", isPresented: $showAlert) {
            Button(role: .destructive) {
                try? viewContext.save()
            } label: {
                Text("Conferma")
            }
            Button("Annulla", role: .cancel) { viewContext.rollback() }
        } message: {
            Text("Cancellando lo scaffale si cancelleranno i libri al suo interno")
        }
        .navigationTitle(bookshelf.name ?? "")
        .listStyle(PlainListStyle())
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(
                        action: { showAddShelfView = true },
                        label: { Image(systemName: "plus"); Text("Aggiungi Scaffale") }
                    )
                    Button(
                        action: { if(isEditable) { try? viewContext.save() }; isEditable.toggle() },
                        label: { Image(systemName: "square.and.pencil"); Text("Modifica Libreria") }
                    )
                }
                label: { Image(systemName: "ellipsis").imageScale(.large).frame(width: 40, height: 60) }
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.move(shelfs, from: source.first!, to: destination, viewContext: viewContext)
    }
}
