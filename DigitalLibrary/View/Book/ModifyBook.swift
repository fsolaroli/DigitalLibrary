//
//  ModifyBook.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 24/06/21.
//

import SwiftUI

struct ModifyBook: View {
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var book: Book

    @State var showCoverScanner = false

    @State var bookshelf: Bookshelf
    
    @FetchRequest(
        entity: Bookshelf.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Bookshelf.index, ascending: true)],
        animation: .default)
    private var bookshelfs: FetchedResults<Bookshelf>
    
    var shelfs: [Shelf] {
        get {
            var shelfs:[Shelf] = []
            bookshelf.shelfs!.forEach({ s in shelfs.append(s as! Shelf)})
            return shelfs.sorted(by: {s1, s2 in s1.index < s2.index})
        }
    }
    
    var alert: Alert {
        Alert(title: Text("Nessun risultato trovato"), message: Text("L'ISBN inserito non esiste o non è presente nel database di Google Books"), dismissButton: .default(Text("OK")))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Posizione"), content: {
                    Picker(selection: $bookshelf, label: Text("Libreria"), content: {
                        ForEach(Array(bookshelfs)) { bookshelf in
                            Text(bookshelf.name!).tag(bookshelf)
                        }
                    })
                    Picker(selection: Binding<Shelf>(
                        get: { book.shelf! },
                        set: { book.shelf = $0 }
                    ), label: Text("Scaffale"), content: {
                        ForEach(shelfs) { shelf in
                            Text(shelf.name!).tag(shelf)
                        }
                    })
                })
                Section(header: Text("Titolo"), content: {
                    TextField("Titolo", text: Binding<String>(
                        get: { book.title ?? "" },
                        set: { book.title = $0 }
                    ))
                })
                Section(
                    header: HStack {
                        Text("Copertina")
                        Spacer()
                        Button(action: { book.cover = nil }, label: { Image(systemName: "minus.circle") }).font(.title2).disabled(book.cover == nil)
                    },
                    content: {
                        if book.cover == nil {
                            Image(systemName: "book.closed").resizable().scaledToFit()
                        } else {
                            Image(uiImage: UIImage(data: book.cover!)!).resizable().scaledToFit()
                        }
                        Button(action: { showCoverScanner = true }, label: {Text("Scansione Copertina")})
                    }
                )
                Section(header: Text("Dati Libro"), content: {
                    TextField("Autore", text: Binding<String>(
                        get: { book.authors ?? "" },
                        set: { book.authors = $0 }
                    ))
                    TextField("Casa editrice", text: Binding<String>(
                        get: { book.editor ?? "" },
                        set: { book.editor = $0 }
                    ))
                    TextField("Anno di pubblicazione", text: Binding<String>(
                        get: { if (book.publishDate != 0) {
                            return String(book.publishDate)
                        } else {
                            return ""
                        }},
                        set: { if let publishDate = Int16($0) {
                            book.publishDate = publishDate }
                        }
                    )).keyboardType(.numberPad)
                    TextField("Numero di pagine", text: Binding<String>(
                        get: { if (book.pageCount != 0) {
                            return String(book.pageCount)
                        } else {
                            return ""
                        }},
                        set: { if let pageCount = Int32($0) {
                            book.pageCount = pageCount }
                        }
                    )).keyboardType(.numberPad)
                })
            }
            .navigationTitle("Modifica Libro")
            .navigationBarItems(
                leading: Button(action: { viewContext.rollback(); presentationMode.wrappedValue.dismiss() }, label: { Text("Annulla") }),
                trailing: Button(
                    action: { try? viewContext.save() },
                    label: { Text("Salva") }
                )
                .disabled(book.title == ""))
        }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.notFound },
            set: { viewModel.notFound = $0 }
        ), content: { self.alert })
        .onDisappear(perform: {viewModel.resetInputBook()})
        
        .sheet(isPresented: $showCoverScanner, content: {
            ScannerCoverView { result in
                switch result {
                    case .success(let scannedImages):
                        book.cover = scannedImages[0].jpegData(compressionQuality: 1.0)
                    case .failure(let error):
                        print(error.localizedDescription)
                }
                showCoverScanner = false
            } didCancelScanning: {
                showCoverScanner = false
            }.edgesIgnoringSafeArea([.bottom])
        })
    }

}
