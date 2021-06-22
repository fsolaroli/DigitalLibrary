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
    
    let isbnBookAPI = "https://www.googleapis.com/books/v1/volumes?q=isbn:"
    
    @Published var inputBook = InputBook()
    
    func getBookDataFromISBN(isbn: String) {
        let session = URLSession(configuration: .default)
        if let url = URL(string: isbnBookAPI + isbn) {
            let task = session.dataTask(with: url) { (data: Data?, response, error) in
                DispatchQueue.main.async {
                    if let bookData = data {
                        let json = try! JSONSerialization.jsonObject(with: bookData, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                        let items = json["items"] as! Array<Any>
                        let book = items[0] as! Dictionary<String, Any>
                        let bookInfo = book["volumeInfo"] as! Dictionary<String, Any>
                        print("BookInfo:\n \(bookInfo)")
                        self.inputBook.title = bookInfo["title"] as? String ?? ""
                        let authors = bookInfo["authors"] as? Array<String> ?? []
                        self.inputBook.author = authors.joined(separator: ", ")
                        self.inputBook.editor = bookInfo["publisher"] as? String ?? ""
                        self.inputBook.publishDate = bookInfo["publishedDate"] as? String ?? ""
                        self.inputBook.ISBN = isbn
                        if let pageCount = bookInfo["pageCount"] as? Int {
                            self.inputBook.pageNumber = String(pageCount)
                        }
                        
                        print("Book: \(self.inputBook)")
                    } else {
                        print("empty response")
                    }
                }
            }
            task.resume()
        }
    }
    
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
    
    
    func addBook(shelf: Shelf, viewContext: NSManagedObjectContext) {
        withAnimation {
            let newBook = Book(context: viewContext)
            
            if let isbn = Int64(inputBook.ISBN) {
                newBook.isbn = isbn
            }
            newBook.title = inputBook.title
            newBook.authors = inputBook.author
            newBook.editor = inputBook.editor
            if let publishDate = Int16(inputBook.publishDate) {
                newBook.publishDate = publishDate
            }
            if let pageCount = Int32(inputBook.pageNumber) {
                newBook.pageCount = pageCount
            }
            newBook.borrowed = false
            newBook.reading = false
            
            if let jpegData = inputBook.cover?.jpegData(compressionQuality: 1.0) {
                newBook.cover = jpegData
            }
            
            shelf.addToBooks(newBook)
            
            do {
                try viewContext.save()
                inputBook = InputBook()
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




