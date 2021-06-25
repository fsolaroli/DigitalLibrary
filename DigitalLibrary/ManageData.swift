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
    
//    @Published var currentBookshelf: Bookshelf? = nil
//    @Published var currentBook: Book? = nil
//
//    func setCurretBookshelf(_ bookshelf: Bookshelf?) {
//        currentBookshelf = bookshelf
//    }
//
//    func setCurretBook(_ book: Book?) {
//        currentBook = book
//    }
    
    @Published var inputBook = InputBook()
    
    @Published var notFound = false
    
    func getBookDataFromISBN(isbn: String) {
        let session = URLSession(configuration: .default)
        if let url = URL(string: isbnBookAPI + isbn) {
            let task = session.dataTask(with: url) { (data: Data?, response, error) in
                DispatchQueue.main.async {
                    if let bookData = data {
                        let json = try! JSONSerialization.jsonObject(with: bookData, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                        if let items = json["items"] as? Array<Any> {
                            let book = items[0] as! Dictionary<String, Any>
                            let bookInfo = book["volumeInfo"] as! Dictionary<String, Any>
                            self.inputBook.title = bookInfo["title"] as? String ?? ""
                            let authors = bookInfo["authors"] as? Array<String> ?? []
                            self.inputBook.author = authors.joined(separator: ", ")
                            self.inputBook.editor = bookInfo["publisher"] as? String ?? ""
                            self.inputBook.publishDate = bookInfo["publishedDate"] as? String ?? ""
                            self.inputBook.ISBN = isbn
                            if let pageCount = bookInfo["pageCount"] as? Int {
                                self.inputBook.pageNumber = String(pageCount)
                            }
                            if let imageLinks = bookInfo["imageLinks"] as? Dictionary<String, String> {
                                var url = imageLinks["thumbnail"]!
                                url.insert("s", at: url.index(url.startIndex, offsetBy: 4))
                                DispatchQueue.global(qos: .background).async {
                                    let data = try? Data(contentsOf: URL(string: url as String)!)
                                    DispatchQueue.main.async {
                                        if let imageData = data {
                                            self.inputBook.cover = UIImage(data: imageData)!
                                        }
                                    }
                                }
                            }
                        } else {
                            self.notFound = true
                        }
                    } else {
                        self.notFound = true
                    }
                }
            }
            task.resume()
        }
    }
    
    func resetInputBook() {
        self.inputBook = InputBook()
    }
    
    func addBookshelf(name: String, index: Int, viewContext: NSManagedObjectContext) {
        withAnimation {
            let newBookshelf = Bookshelf(context: viewContext)
            newBookshelf.name = name
            newBookshelf.index = Int64(index)
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
    
    func addShelf(name: String, index: Int, bookshelf: Bookshelf, viewContext: NSManagedObjectContext) {
        withAnimation {
            let newShelf = Shelf(context: viewContext)
            newShelf.name = name
            newShelf.index = Int64(index)
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
    
    
    func addBook(shelf: Shelf, index: Int, viewContext: NSManagedObjectContext) {
        withAnimation {
            let newBook = Book(context: viewContext)
            
            if let isbn = Int64(inputBook.ISBN) {
                newBook.isbn = isbn
            }
            newBook.title = inputBook.title
            newBook.authors = inputBook.author
            newBook.editor = inputBook.editor
            newBook.index = Int64(index)
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
    
    func move(_ array: Array<Bookshelf>, from source: Int, to destination: Int, viewContext: NSManagedObjectContext) {
        if (source != destination) {
            
            array[source].index = Int64(destination - 1)
            
            if(source < destination) {
                for element in array[(source + 1) ..< destination] {
                    element.index = element.index - 1
                }
            } else {
                for element in array[destination ..< source] {
                    element.index = element.index + 1
                }
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
    
    func move(_ array: Array<Shelf>, from source: Int, to destination: Int, viewContext: NSManagedObjectContext) {
        if (source != destination) {
            
            array[source].index = Int64(destination - 1)
            
            if(source < destination) {
                for element in array[(source + 1) ..< destination] {
                    element.index = element.index - 1
                }
            } else {
                for element in array[destination ..< source] {
                    element.index = element.index + 1
                }
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
    
    func move(_ array: Array<Book>, from source: Int, to destination: Int, viewContext: NSManagedObjectContext) {
        if (source != destination) {
            
            array[source].index = Int64(destination - 1)
            
            if(source < destination) {
                for element in array[(source + 1) ..< destination] {
                    element.index = element.index - 1
                }
            } else {
                for element in array[destination ..< source] {
                    element.index = element.index + 1
                }
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
    
    func delete<I: NSManagedObject>(_ item: I, viewContext: NSManagedObjectContext) {
        viewContext.delete(item)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
