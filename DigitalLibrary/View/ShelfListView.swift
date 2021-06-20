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
    
    @State var showAddShelfView = false
    
    @ObservedObject var bookshelf: Bookshelf
    
    var body: some View {
        List {
            ForEach(Array(bookshelf.shelfs?.set ?? []),id: \.self) { shelf in
                ShelfView(viewModel: viewModel, shelf: shelf as! Shelf)
            }.onDelete(perform: { indexSet in
                var itemsToRemove = [Shelf]()
                for indexToRemove in indexSet {
                    itemsToRemove.append((bookshelf.shelfs?.object(at: indexToRemove)) as! Shelf)
                }
                
                viewModel.delete(itemsToRemove, viewContext: viewContext)
            })
        }.navigationTitle(bookshelf.name ?? "")
        .listStyle(PlainListStyle())
        .navigationBarItems(trailing: Button(
            action: {
                showAddShelfView = true
            },
            label: {
                Image(systemName: "plus.circle").imageScale(.large)
            }
        )).sheet(isPresented: $showAddShelfView, content: {
            AddShelf(viewModel: viewModel, bookshelf: bookshelf)
                .environment(\.managedObjectContext, viewContext)
        })
    }
}
