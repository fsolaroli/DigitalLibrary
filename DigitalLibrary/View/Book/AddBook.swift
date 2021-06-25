//
//  AddBook.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 20/06/21.
//

import SwiftUI
import CarBode
import AVFoundation

struct AddBook: View {
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var shelf: Shelf
     
    @State var showBarcodeScanner = false
    @State var showCoverScanner = false
    @State var torchIsOn = false

    func disableAll() {
        torchIsOn = false
        showBarcodeScanner = false
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Titolo"), content: {
                        TextField("Titolo", text: $viewModel.inputBook.title)
                    })
                    Section(
                        header: HStack {
                            Text("Copertina")
                            Spacer()
                            Button(action: { viewModel.inputBook.cover = nil }, label: { Image(systemName: "minus.circle") }).font(.title2).disabled(viewModel.inputBook.cover == nil)
                        },
                        content: {
                            if viewModel.inputBook.cover == nil {
                                Image(systemName: "book.closed").resizable().scaledToFit()
                            } else {
                                Image(uiImage: viewModel.inputBook.cover!).resizable().scaledToFit()
                            }
                            Button(action: { showCoverScanner = true }, label: {Text("Scansione Copertina")})
                        }
                    )
                    Section(header: Text("Dati Libro"), content: {
                        TextField("Autore", text: $viewModel.inputBook.author)
                        TextField("Casa editrice", text: $viewModel.inputBook.editor)
                        TextField("Anno di pubblicazione", text: $viewModel.inputBook.publishDate).keyboardType(.numberPad)
                        TextField("Numero di pagine", text: $viewModel.inputBook.pageNumber).keyboardType(.numberPad)
                    })
                }
                Divider().padding(.bottom, 5)
                Button(
                    action: { showBarcodeScanner = true },
                    label: {
                        HStack {
                            Image(systemName: "barcode.viewfinder")
                                .renderingMode(.template)
                                .foregroundColor(Color(UIColor.systemBlue))
                            
                            Text("Scan ISBN")
                                .foregroundColor(Color(UIColor.systemBlue))
                        }
                        .font(.title2)
                        .foregroundColor(Color(UIColor.systemBlue))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .cornerRadius(40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color(UIColor.systemBlue), lineWidth: 2)
                        )
                    }
                ).padding(.bottom, 5)
            }.navigationTitle("Aggiungi Libro")
            .navigationBarItems(
                leading: Button(action: { presentationMode.wrappedValue.dismiss() }, label: { Text("Annulla") }),
                trailing: Button(
                    action: {
                        viewModel.addBook(
                            shelf: shelf,
                            index: shelf.books?.count ?? 0,
                            viewContext: viewContext
                        )
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: { Text("Aggiungi") }
                )
                .disabled(viewModel.inputBook.title == ""))
        }
        .alert(
            isPresented: Binding<Bool>(
                get: { viewModel.notFound },
                set: { viewModel.notFound = $0 }
            ),
            content: {
                Alert(title: Text("Nessun risultato trovato"), message: Text("L'ISBN inserito non esiste o non è presente nel database di Google Books"), dismissButton: .default(Text("OK")))
            }
        )
        .sheet(isPresented: $showBarcodeScanner, content: { BarcodeScannerView(viewModel: viewModel) })
        .sheet(isPresented: $showCoverScanner, content: {
            ScannerCoverView { result in
                switch result {
                    case .success(let scannedImages):
                        viewModel.inputBook.cover = scannedImages[0]
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
