//
//  DigitalLibraryUITests.swift
//  DigitalLibraryUITests
//
//  Created by Fabio Solaroli on 09/11/22.
//

import XCTest

final class DigitalLibraryUITests: XCTestCase {

    var app: XCUIApplication!
     
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
        app.buttons["RESET"].tap()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialApplicationState() throws {
        let bookshelf = app.collectionViews["bookshelfsList"].buttons["La mia prima libreria"]
        XCTAssertTrue(bookshelf.exists)
        bookshelf.tap()
        let shelf = app.collectionViews["shelfsList"]/*@START_MENU_TOKEN@*/.buttons["Primo scaffale"]/*[[".cells",".buttons[\"Primo scaffale, 1\"]",".buttons[\"Primo scaffale\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(shelf.exists)
        shelf.tap()
        let book = app.collectionViews["booksList"].buttons["Primo Libro"]
        XCTAssertTrue(book.exists)
    }
    
    func testAddBook() throws {
        app.collectionViews["bookshelfsList"]/*@START_MENU_TOKEN@*/.buttons["La mia prima libreria"]/*[[".cells",".buttons[\"La mia prima libreria, 1\"]",".buttons[\"La mia prima libreria\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews["shelfsList"]/*@START_MENU_TOKEN@*/.buttons["Primo scaffale"]/*[[".cells",".buttons[\"Primo scaffale, 1\"]",".buttons[\"Primo scaffale\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Primo scaffale"]/*@START_MENU_TOKEN@*/.buttons["ShelfMenu"]/*[[".otherElements[\"More\"]",".buttons[\"More\"]",".buttons[\"ShelfMenu\"]",".otherElements[\"ShelfMenu\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["Aggiungi Libro"]/*[[".cells.buttons[\"Aggiungi Libro\"]",".buttons[\"Aggiungi Libro\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews["NewBookForm"]/*@START_MENU_TOKEN@*/.textFields["Titolo"]/*[[".cells.textFields[\"Titolo\"]",".textFields[\"Titolo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews["NewBookForm"]/*@START_MENU_TOKEN@*/.textFields["Titolo"]/*[[".cells.textFields[\"Titolo\"]",".textFields[\"Titolo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("New Book")
        app.navigationBars["Aggiungi Libro"]/*@START_MENU_TOKEN@*/.buttons["Aggiungi"]/*[[".otherElements[\"Aggiungi\"].buttons[\"Aggiungi\"]",".buttons[\"Aggiungi\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertTrue(app.collectionViews["booksList"]/*@START_MENU_TOKEN@*/.buttons["New Book"]/*[[".cells",".buttons[\"New Book, New Book, Autore: , Casa editrice: , Anno di pubblicazione: , Numero di pagine: \"]",".buttons[\"New Book\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.exists)
    }
    
    func testAddBookshelf() throws {
        app.navigationBars["Librerie"]/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".otherElements[\"Add\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.alerts["Nuova Libreria"].scrollViews.otherElements.collectionViews.cells.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element.typeText("New Bookshelf")
                
        app.alerts["Nuova Libreria"].scrollViews.otherElements.buttons["Aggiungi"].tap()
        
        XCTAssertTrue(app.collectionViews["bookshelfsList"]/*@START_MENU_TOKEN@*/.buttons["New Bookshelf"]/*[[".cells",".buttons[\"New Bookshelf, 0\"]",".buttons[\"New Bookshelf\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.exists)
        
        app.collectionViews["bookshelfsList"]/*@START_MENU_TOKEN@*/.buttons["New Bookshelf"]/*[[".cells",".buttons[\"New Bookshelf, 0\"]",".buttons[\"New Bookshelf\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertTrue(app.collectionViews["shelfsList"].buttons["Primo scaffale"].exists)
        
        app.collectionViews["shelfsList"].buttons["Primo scaffale"].tap()
        
        XCTAssertEqual(0, app.collectionViews["bookList"].buttons.count)
    }
    
    func testDeleteBook() throws {
        app.collectionViews["bookshelfsList"]/*@START_MENU_TOKEN@*/.buttons["La mia prima libreria"]/*[[".cells",".buttons[\"La mia prima libreria, 2\"]",".buttons[\"La mia prima libreria\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews["shelfsList"]/*@START_MENU_TOKEN@*/.buttons["Primo scaffale"]/*[[".cells",".buttons[\"Primo scaffale, 2\"]",".buttons[\"Primo scaffale\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.collectionViews["booksList"]/*@START_MENU_TOKEN@*/.buttons["Primo Libro"]/*[[".cells",".buttons[\"Primo Libro, Primo Libro, Autore: , Casa editrice: , Anno di pubblicazione: , Numero di pagine: \"]",".buttons[\"Primo Libro\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.scrollViews.otherElements.buttons["Rimuovi libro"].tap()
        app.alerts["Attenzione"].scrollViews.otherElements.buttons["Conferma"].tap()
        
        XCTAssertFalse(app.collectionViews["booksList"].buttons["Primo Libro"].exists)
    }
    
    
    func testDeleteBookshelf() throws {
        app.collectionViews["bookshelfsList"]/*@START_MENU_TOKEN@*/.buttons["La mia prima libreria"]/*[[".cells",".buttons[\"La mia prima libreria, 1\"]",".buttons[\"La mia prima libreria\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        app.otherElements.buttons["Elimina"].tap()
        app.alerts["Attenzione"].scrollViews.otherElements.buttons["Conferma"].tap()
        
        XCTAssertFalse(app.collectionViews["bookshelsfList"].buttons["La mia prima libereria"].exists)
    }
    
    func testAddBookWithISBN() throws {
        app.tabBars["Tab Bar"].buttons["Libri"].tap()
        
        app.navigationBars["Libri"]/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".otherElements[\"Add\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Scan ISBN"].tap()
        app.textFields["ISBN"].tap()
        app.textFields["ISBN"].typeText("9780990582908")
        
        app.buttons["Conferma"].tap()
        
        XCTAssertTrue(app.staticTexts["Game Programming Patterns"].waitForExistence(timeout: 2))
        
        app.buttons["Conferma"].tap()
        
        let newbookformCollectionView = app.collectionViews["NewBookForm"]
        
        newbookformCollectionView/*@START_MENU_TOKEN@*/.staticTexts["La mia prima libreria"]/*[[".cells",".buttons[\"Libreria, La mia prima libreria\"].staticTexts[\"La mia prima libreria\"]",".staticTexts[\"La mia prima libreria\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["La mia prima libreria"]/*[[".cells.buttons[\"La mia prima libreria\"]",".buttons[\"La mia prima libreria\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        newbookformCollectionView/*@START_MENU_TOKEN@*/.staticTexts["Primo scaffale"]/*[[".cells",".buttons[\"Scaffale, Primo scaffale\"].staticTexts[\"Primo scaffale\"]",".staticTexts[\"Primo scaffale\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews.buttons["Primo scaffale"].tap()
        
        app.navigationBars["Aggiungi Libro"]/*@START_MENU_TOKEN@*/.buttons["Aggiungi"]/*[[".otherElements[\"Aggiungi\"].buttons[\"Aggiungi\"]",".buttons[\"Aggiungi\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
//        let newBook = app.scrollViews.otherElements.containing(.staticText, identifier:"G").children(matching: .other).element(boundBy: 0).children(matching: .button).element
//        XCTAssertTrue(newBook.exists) // MARK: IMPORTANT
                let newBook = app.scrollViews.otherElements.buttons["Game Programming Patterns"]
        newBook.tap()
        
        let bookviewScrollView = XCUIApplication().scrollViews["BookView"]
        app.scrollViews["BookView"].swipeUp()
        
        XCTAssertTrue(bookviewScrollView.otherElements.staticTexts["Robert Nystrom"].exists)
        XCTAssertTrue(bookviewScrollView.otherElements.staticTexts["345"].exists)
        
        app.tabBars["Tab Bar"].buttons["Librerie"].tap()
        app.collectionViews["bookshelfsList"]/*@START_MENU_TOKEN@*/.buttons["La mia prima libreria"]/*[[".cells",".buttons[\"La mia prima libreria, 2\"]",".buttons[\"La mia prima libreria\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews["shelfsList"]/*@START_MENU_TOKEN@*/.buttons["Primo scaffale"]/*[[".cells",".buttons[\"Primo scaffale, 2\"]",".buttons[\"Primo scaffale\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertTrue(app.collectionViews["booksList"].buttons["Game Programming Patterns"].exists)
    }
    
    func testFilterBooks() throws {
        try addBook(bookshelf: "La mia prima libreria", shelf: "Primo scaffale", title: "TestBook1")
        try addBook(bookshelf: "La mia prima libreria", shelf: "Primo scaffale", title: "TestBook2")
        
        app.tabBars["Tab Bar"].buttons["Libri"].tap()
        app.navigationBars["Libri"].searchFields["Filtra libri"].tap()
        app.navigationBars["Libri"].searchFields["Filtra libri"].typeText("TestBook")
        
        XCTAssertEqual(2, app.scrollViews.otherElements.buttons.count)
    }
    
    func testFilterWithoutResults() throws {
        app.tabBars["Tab Bar"].buttons["Libri"].tap()
        app.navigationBars["Libri"].searchFields["Filtra libri"].tap()
        app.navigationBars["Libri"].searchFields["Filtra libri"].typeText("NoResults")
        
        XCTAssertTrue(app.scrollViews.staticTexts["Nessun libro corrisponde ai criteri della ricerca"].exists)
    }
    
    func testFavouriteFiltering() throws {
        app.collectionViews["bookshelfsList"]/*@START_MENU_TOKEN@*/.buttons["La mia prima libreria"]/*[[".cells",".buttons[\"La mia prima libreria, 1\"]",".buttons[\"La mia prima libreria\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews["shelfsList"]/*@START_MENU_TOKEN@*/.scrollViews["Primo scaffale"]/*[[".cells.scrollViews[\"Primo scaffale\"]",".scrollViews[\"Primo scaffale\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.buttons["Primo Libro"].tap()
        app.scrollViews.otherElements.buttons["Favorite"].tap()
        app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["La mia prima libreria"].tap()
        
        // on the cover there is the star
        app.tabBars["Tab Bar"].buttons["Libri"].tap()
        app.navigationBars["Libri"]/*@START_MENU_TOKEN@*/.buttons["favouriteFilter"]/*[[".otherElements[\"Favorite\"]",".buttons[\"Favorite\"]",".buttons[\"favouriteFilter\"]",".otherElements[\"favouriteFilter\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertGreaterThanOrEqual(1, app.scrollViews.otherElements.buttons.count)
    }
    
    func testMoveBooks() throws {
        try addBook(bookshelf: "La mia prima libreria", shelf: "Primo scaffale", title: "TestBook")
        try addBookshelf(bookshelf: "New bookshelf")
        
        app.collectionViews["bookshelfsList"]/*@START_MENU_TOKEN@*/.buttons["La mia prima libreria"]/*[[".cells",".buttons[\"La mia prima libreria, 2\"]",".buttons[\"La mia prima libreria\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews["shelfsList"]/*@START_MENU_TOKEN@*/.buttons["Primo scaffale"]/*[[".cells",".buttons[\"Primo scaffale, 2\"]",".buttons[\"Primo scaffale\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.navigationBars["Primo scaffale"]/*@START_MENU_TOKEN@*/.buttons["ShelfMenu"]/*[[".otherElements[\"More\"]",".buttons[\"More\"]",".buttons[\"ShelfMenu\"]",".otherElements[\"ShelfMenu\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["Muovi libri"]/*[[".cells.buttons[\"Muovi libri\"]",".buttons[\"Muovi libri\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let verticalScrollBar1PageCollectionViewsQuery = app.collectionViews.containing(.other, identifier:"Vertical scroll bar, 1 page")
        verticalScrollBar1PageCollectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        verticalScrollBar1PageCollectionViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["Libreria, La mia prima libreria"]/*[[".cells.buttons[\"Libreria, La mia prima libreria\"]",".buttons[\"Libreria, La mia prima libreria\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews.buttons["New bookshelf"].tap()
        app.collectionViews.buttons["Scaffale, Primo scaffale"].tap()
        app.collectionViews.buttons["Primo scaffale"].tap()
        
        XCUIApplication().navigationBars["Muovi libri"]/*@START_MENU_TOKEN@*/.buttons["Muovi"]/*[[".otherElements[\"Muovi\"].buttons[\"Muovi\"]",".buttons[\"Muovi\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertEqual(0, app.collectionViews["booksList"].buttons.count)
        
        app.navigationBars["Primo scaffale"].buttons["La mia prima libreria"].tap()
        app.navigationBars["La mia prima libreria"].buttons["Librerie"].tap()
        
        app.collectionViews["bookshelfsList"]/*@START_MENU_TOKEN@*/.buttons["New bookshelf"]/*[[".cells",".buttons[\"New bookshelf, 0\"]",".buttons[\"New bookshelf\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews["shelfsList"]/*@START_MENU_TOKEN@*/.buttons["Primo scaffale"]/*[[".cells",".buttons[\"Primo scaffale, 2\"]",".buttons[\"Primo scaffale\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertEqual(2, app.collectionViews["booksList"].buttons.count)
    }
    
    func testSwipeToReveal() throws {
        for i in 1...5 {
            try addBook(bookshelf: "La mia prima libreria", shelf: "Primo scaffale", title: "Book" + String(i))
        }
        
        app.collectionViews["bookshelfsList"]/*@START_MENU_TOKEN@*/.buttons["La mia prima libreria"]/*[[".cells",".buttons[\"La mia prima libreria, 11\"]",".buttons[\"La mia prima libreria\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.collectionViews["shelfsList"]/*@START_MENU_TOKEN@*/.scrollViews["Primo scaffale"]/*[[".cells.scrollViews[\"Primo scaffale\"]",".scrollViews[\"Primo scaffale\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0).children(matching: .other).element.swipeLeft()
        
        XCTAssertTrue(app.collectionViews["shelfsList"]/*@START_MENU_TOKEN@*/.scrollViews["Primo scaffale"]/*[[".cells.scrollViews[\"Primo scaffale\"]",".scrollViews[\"Primo scaffale\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.buttons["Book5"].exists)

    }
    
    func addBook(bookshelf: String, shelf: String, title: String) throws {
        app.collectionViews["bookshelfsList"].buttons[bookshelf].tap()
        app.collectionViews["shelfsList"].buttons[shelf].tap()
        app.navigationBars[shelf]/*@START_MENU_TOKEN@*/.buttons["ShelfMenu"]/*[[".otherElements[\"More\"]",".buttons[\"More\"]",".buttons[\"ShelfMenu\"]",".otherElements[\"ShelfMenu\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["Aggiungi Libro"]/*[[".cells.buttons[\"Aggiungi Libro\"]",".buttons[\"Aggiungi Libro\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews["NewBookForm"]/*@START_MENU_TOKEN@*/.textFields["Titolo"]/*[[".cells.textFields[\"Titolo\"]",".textFields[\"Titolo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews["NewBookForm"]/*@START_MENU_TOKEN@*/.textFields["Titolo"]/*[[".cells.textFields[\"Titolo\"]",".textFields[\"Titolo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText(title)
        app.navigationBars["Aggiungi Libro"]/*@START_MENU_TOKEN@*/.buttons["Aggiungi"]/*[[".otherElements[\"Aggiungi\"].buttons[\"Aggiungi\"]",".buttons[\"Aggiungi\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars[shelf].buttons["La mia prima libreria"].tap()
        app.navigationBars[bookshelf].buttons["Librerie"].tap()
    }
    
    func addBookshelf(bookshelf: String) throws {
        app.navigationBars["Librerie"]/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".otherElements[\"Add\"].buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Nuova Libreria"].scrollViews.otherElements.collectionViews.cells.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element.typeText(bookshelf)
        app.alerts["Nuova Libreria"].scrollViews.otherElements.buttons["Aggiungi"].tap()
    }
}
