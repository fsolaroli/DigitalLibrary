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
    @Published var newInputBook = InputBook()
    
    @Published var notFound = false
    
    func getBookDataFromISBN(isbn: String) {
        notFound = false
        newInputBook = InputBook()
        newInputBook.ISBN = isbn
        let session = URLSession(configuration: .default)
        if let url = URL(string: isbnBookAPI + isbn) {
            let task = session.dataTask(with: url) { (data: Data?, response, error) in
                DispatchQueue.main.async {
                    if let bookData = data {
                        let json = try! JSONSerialization.jsonObject(with: bookData, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                        if let items = json["items"] as? Array<Any> {
                            let book = items[0] as! Dictionary<String, Any>
                            let bookInfo = book["volumeInfo"] as! Dictionary<String, Any>
                            self.newInputBook.title = bookInfo["title"] as? String ?? ""
                            let authors = bookInfo["authors"] as? Array<String> ?? []
                            self.newInputBook.author = authors.joined(separator: ", ")
                            self.newInputBook.editor = bookInfo["publisher"] as? String ?? ""
                            self.newInputBook.publishDate = bookInfo["publishedDate"] as? String ?? ""
                            if let pageCount = bookInfo["pageCount"] as? Int {
                                self.newInputBook.pageNumber = String(pageCount)
                            }
                            if let imageLinks = bookInfo["imageLinks"] as? Dictionary<String, String> {
                                var url = imageLinks["thumbnail"]!
                                url.insert("s", at: url.index(url.startIndex, offsetBy: 4))
                                DispatchQueue.global(qos: .background).async {
                                    let data = try? Data(contentsOf: URL(string: url as String)!)
                                    DispatchQueue.main.async {
                                        if let imageData = data {
                                            self.newInputBook.cover = UIImage(data: imageData)!
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
    
    func resetNewInputBook() {
        self.newInputBook = InputBook()
    }
    
    func addBookshelf(name: String, index: Int, viewContext: NSManagedObjectContext) {
        withAnimation {
            let newBookshelf = Bookshelf(context: viewContext)
            newBookshelf.name = name
            newBookshelf.index = Int64(index)
            try? viewContext.save()
        }
    }
    
    func addShelf(name: String, index: Int, bookshelf: Bookshelf, viewContext: NSManagedObjectContext) {
        withAnimation {
            let newShelf = Shelf(context: viewContext)
            newShelf.name = name
            newShelf.index = Int64(index)
            bookshelf.addToShelfs(newShelf)
            try? viewContext.save()
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
            newBook.reading = false
            
            if let jpegData = inputBook.cover?.jpegData(compressionQuality: 1.0) {
                newBook.cover = jpegData
            }
            
            shelf.addToBooks(newBook)
            
            try? viewContext.save()
            inputBook = InputBook()
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
           
            try? viewContext.save()
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
           
            try? viewContext.save()
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
           
            try? viewContext.save()
        }
    }
    
    func delete<I: NSManagedObject>(_ item: I, viewContext: NSManagedObjectContext) {
        withAnimation {
            viewContext.delete(item)
            try? viewContext.save()
        }
    }
    
    func delete<I: NSManagedObject>(_ items: [I], viewContext: NSManagedObjectContext) {
        withAnimation {
            for item in items {
                viewContext.delete(item)
            }
            
            try? viewContext.save()
        }
    }
}
