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
    
    @State var showCodebarScanner = false
    @State var showCoverScanner = false
    @State var torchIsOn = false
    
    @State var ISBN = ""
    @State var title = ""
    @State var cover = Image(systemName: "photo")
    
    func disableAll() {
        torchIsOn = false
        showCodebarScanner = false
        UIApplication.shared.endEditing()
    }
    
    var body: some View {
        ZStack {
            VStack {
                
                Spacer()
                
                HStack {
                    Button(action: { disableAll() }, label: { Text("Annulla") })
                    Spacer()
                    Button(
                        action: {
                            disableAll()
                            // TODO: search ISBN
                        },
                        label: { Text("Conferma") })
                }.padding(.horizontal).padding(.top)

                TextField("ISBN", text: $ISBN).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal)
                
                ZStack {
                    CBScanner(
                        supportBarcode: .constant([.ean13]),
                        torchLightIsOn: $torchIsOn,
                        scanInterval: .constant(1.0)
                    ){ result in
                        ISBN = result.value
                    }.disabled(!showCodebarScanner)
                    
                    VStack {
                        
                        Spacer()
                        
                        HStack {
                            Button(
                                action: { torchIsOn.toggle() },
                                label: { Image(systemName: torchIsOn ? "flashlight.on.fill" : "flashlight.off.fill")
                                    .padding()
                                    .background(Color(UIColor.systemBackground))
                                    .clipShape(Circle())
                                    .font(.largeTitle)
                                }
                                
                            )
                        }
                    }.padding(.bottom)
                        
                }.edgesIgnoringSafeArea([.bottom])
                
            }.hidden(!showCodebarScanner && showCoverScanner)
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
            }.hidden(!showCoverScanner && showCodebarScanner)
            NavigationView {
                Form {
                    Section(header: Text("Copertina"), content: {
                        cover.resizable().scaledToFit()
                        Button(action: { showCoverScanner = true }, label: {Text("Scansione Copertina")})
                    })
                    Section(header: Text("Dati Libro"), content: {
                        TextField("Titolo", text: $title)
                        TextField("Titolo", text: $title)
                        
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
                    action: { showCodebarScanner = true },
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
                )).padding(.top)
            }.hidden(showCodebarScanner && showCoverScanner)
        }
    }
}
