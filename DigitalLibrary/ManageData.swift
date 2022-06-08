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
    
    init(viewContext: NSManagedObjectContext) {
        if (UserDefaults.standard.object(forKey: "newUser") as? Bool ?? true) {
            let newBookshelf = addBookshelf(name: "La mia prima libreria", index: 0, viewContext: viewContext)
            inputBook.title = "Primo Libro"
            addBook(shelf: newBookshelf.shelfs![0] as! Shelf, index: 0, viewContext: viewContext)
            UserDefaults.standard.set(false, forKey: "newUser")
        }
    }
    
    func numberOfBooks(in bookshelf: Bookshelf) -> String {
        var numberOfBooks = 0
        if let shelfs = bookshelf.shelfs {
            for shelf in shelfs {
                if let books = (shelf as! Shelf).books {
                    numberOfBooks += books.count
                }
            }
        }
        
        return String(numberOfBooks)
    }
    
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
        } else {
            self.notFound = true
        }
    }
    
    func resetInputBook() {
        self.inputBook = InputBook()
    }
    
    func resetNewInputBook() {
        self.newInputBook = InputBook()
    }
    
    func addBookshelf(name: String, index: Int, viewContext: NSManagedObjectContext) -> Bookshelf {
        withAnimation {
            let newBookshelf = Bookshelf(context: viewContext)
            newBookshelf.name = name
            newBookshelf.index = Int64(index)
            addShelf(name: "Primo scaffale", index: 0, bookshelf: newBookshelf, viewContext: viewContext)
            try? viewContext.save()
            return newBookshelf
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
            resetInputBook()
        }
    }
    
    func move(_ array: Array<Bookshelf>, from source: Int, to destination: Int, viewContext: NSManagedObjectContext) {
        if (source != destination) {
            
            
            if(source < destination) {
                array[source].index = Int64(destination - 1)
                for element in array[(source + 1) ..< destination] {
                    element.index = element.index - 1
                }
            } else {
                array[source].index = Int64(destination)
                for element in array[destination ..< source] {
                    element.index = element.index + 1
                }
            }
           
            try? viewContext.save()
        }
    }
    
    func delete(_ bookshelf: Bookshelf, from array: Array<Bookshelf>, viewContext: NSManagedObjectContext) {
        let index = array.firstIndex(of: bookshelf)!
        
        for element in array[(index + 1) ..< array.count] {
            element.index = element.index - 1
        }
        
        viewContext.delete(bookshelf)
        
//        try? viewContext.save()
    }
    
    func move(_ array: Array<Shelf>, from source: Int, to destination: Int, viewContext: NSManagedObjectContext) {
        if (source != destination) {
            if(source < destination) {
                array[source].index = Int64(destination - 1)
                for element in array[(source + 1) ..< destination] {
                    element.index = element.index - 1
                }
            } else {
                array[source].index = Int64(destination)
                for element in array[(destination) ..< source] {
                    element.index = element.index + 1
                }
            }

            try? viewContext.save()
        }
    }
    
    func delete(_ shelf: Shelf, from array: Array<Shelf>, viewContext: NSManagedObjectContext) {
        let index = array.firstIndex(of: shelf)!
        
        for element in array[(index + 1) ..< array.count] {
            element.index = element.index - 1
        }
        
        viewContext.delete(shelf)
        
//        try? viewContext.save()
    }
    
    func move(_ array: Array<Book>, from source: Int, to destination: Int, viewContext: NSManagedObjectContext) {
        if (source != destination) {
            if(source < destination) {
                array[source].index = Int64(destination - 1)
                for element in array[(source + 1) ..< destination] {
                    element.index = element.index - 1
                }
            } else {
                array[source].index = Int64(destination)
                for element in array[(destination) ..< source] {
                    element.index = element.index + 1
                }
            }

            try? viewContext.save()
        }
    }
    
    func move(_ books: Set<Book>, from array: Array<Book>, to destination: Shelf, viewContext: NSManagedObjectContext) {
        var mutableArray = array
        for book in books {
            move(book, from: mutableArray, to: destination)
            mutableArray.remove(at: mutableArray.firstIndex(of: book)!)
        }
        
        try? viewContext.save()
    }
    
    func move(_ book: Book, from array: Array<Book>, to destination: Shelf) {
        if (book.shelf != destination) {
            let source = array.firstIndex(of: book)!
            
            for element in array[(source + 1) ..< array.count] {
                element.index = element.index - 1
            }
            
            array[source].index = Int64(destination.books?.count ?? 0)
            
            array[source].shelf = destination
        }
        
    }
    
    func delete(_ book: Book, from array: Array<Book>, viewContext: NSManagedObjectContext) {
        let index = array.firstIndex(of: book)!
        
        for element in array[(index + 1) ..< array.count] {
            element.index = element.index - 1
        }
        
        viewContext.delete(book)
        
//        try? viewContext.save()
    }

    
    func fix(_ tofix: Array<Book>, viewContext: NSManagedObjectContext) {
        var i: Int = 0;
        for book in tofix {
            book.index = Int64(i)
            i = i + 1
        }
        try? viewContext.save()
    }
}
