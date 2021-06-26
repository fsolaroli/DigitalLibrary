//
//  HomeView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 25/06/21.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var currentView = true
    
    var body: some View {
        TabView {
            BookshelfListView(viewModel: viewModel).tabItem {
                Label("Librerie", systemImage: "books.vertical.fill")
            }
            .environment(\.managedObjectContext, viewContext)
            
            AllBookGridView(viewModel: viewModel).tabItem {
                Label("Libri", systemImage: "square.grid.2x2.fill")
            }
            .environment(\.managedObjectContext, viewContext)
        }
    }
}
