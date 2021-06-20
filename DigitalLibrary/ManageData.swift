//
//  DataLoader.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 19/06/21.
//

import Foundation
import SwiftUI
import CoreData

class ManageData: ObservableObject {
    
    func addBookshelf(name: String, viewContext: NSManagedObjectContext) {
        withAnimation {
            let newBookshelf = Bookshelf(context: viewContext)
            newBookshelf.name = name
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func addShelf(name: String, bookshelf: Bookshelf, viewContext: NSManagedObjectContext) {
        withAnimation {
            let newShelf = Shelf(context: viewContext)
            newShelf.name = name
            bookshelf.addToShelfs(newShelf)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    func addBook(title: String, shelf: Shelf, viewContext: NSManagedObjectContext) {
        withAnimation {
            let newBook = Book(context: viewContext)
            newBook.title = title
            newBook.borrowed = false
            newBook.reading = false 
            shelf.addToBooks(newBook)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func delete<I: NSManagedObject>(_ items: [I], viewContext: NSManagedObjectContext) {
        withAnimation {
            for item in items {
                viewContext.delete(item)
            }
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}




