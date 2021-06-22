//
//  DigitalLibraryApp.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import SwiftUI

@main
struct DigitalLibraryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            BookLibraryListView(viewModel: ManageData())
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
