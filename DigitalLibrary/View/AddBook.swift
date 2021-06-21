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
    
    var viewModel: ManageData
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var shelf: Shelf
    
    @State var showBarcodeScanner = false
    @State var showCoverScanner = false
    @State var torchIsOn = false
    
    @State var ISBN = ""
    @State var title = ""
    @State var cover = Image(systemName: "photo")
    @State var author = ""
    
    func disableAll() {
        torchIsOn = false
        showBarcodeScanner = false
        UIApplication.shared.endEditing()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Titolo"), content: {
                    TextField("Titolo", text: $title)
                })
                Section(header: Text("Copertina"), content: {
                    cover.resizable().scaledToFit()
                    Button(action: { showCoverScanner = true }, label: {Text("Scansione Copertina")})
                })
                Section(header: Text("Dati Libro"), content: {
                    TextField("Autore", text: $author)
                    
                })
                Button(
                    action: {
                        viewModel.addBook(
                            title: title,
                            shelf: shelf,
                            viewContext: viewContext
                        )
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: { Text("Aggiungi Libro") }
                ).disabled(title == "")
            }.navigationTitle("Aggiungi Libro")
            .navigationBarItems(trailing: Button(
                action: { showBarcodeScanner = true },
                label: {
                    HStack {
                        Image(systemName: "barcode.viewfinder")
                            .renderingMode(.template)
                            .foregroundColor(Color(UIColor.systemBlue))
                        
                        Text("Scan ISBN")
                            .foregroundColor(Color(UIColor.systemBlue))
                    }
                    .font(.subheadline)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .cornerRadius(40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color(UIColor.systemBlue), lineWidth: 2)
                    )
                }
            ))
        }
        .sheet(isPresented: $showBarcodeScanner, content: { BarcodeScannerView() })
        .sheet(isPresented: $showCoverScanner, content: {
            ScannerCoverView { result in
                switch result {
                    case .success(let scannedImages):
                        cover = Image(uiImage: scannedImages[0])

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
