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
    
    @State private var tabSelection = 1
   
    @State private var tappedTwice: Bool = false

    @State private var libraries = UUID()
    @State private var books = UUID()

    var body: some View {
//            var handler: Binding<Int> { Binding(
//                    get: { self.tabSelection },
//                    set: {
//                        if $0 == self.tabSelection {
//                            // Lands here if user tapped more than once
//                            tappedTwice = true
//                        }
//                        self.tabSelection = $0
//                    }
//            )}
//
//        return TabView(selection: handler) {
//            BookshelfListView(viewModel: viewModel, id: libraries)
//                .environment(\.managedObjectContext, viewContext)
//                .onChange(of: tappedTwice, perform: { tappedTwice in
//                    guard tappedTwice else { return }
//                    libraries = UUID()
//                    print("double tapped 2.0")
//                    self.tappedTwice = false
//                })
//            .tabItem { Label("Librerie", systemImage: "books.vertical.fill") }
//            .tag(1)
//
//            AllBookGridView(viewModel: viewModel, id: books)
//                .environment(\.managedObjectContext, viewContext)
//                .onChange(of: tappedTwice, perform: { tappedTwice in
//                    guard tappedTwice else { return }
//                    books = UUID()
//                    self.tappedTwice = false
//                 })
//             .tabItem { Label("Libri", systemImage: "square.grid.2x2.fill") }
//             .tag(2)
//        }
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
