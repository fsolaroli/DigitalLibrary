//
//  BarcodeScannerView.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 21/06/21.
//

import SwiftUI
import CarBode
import AVFoundation

struct BarcodeScannerView: View {
    
    @ObservedObject var viewModel: ManageData
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var torchIsOn = false
    @State var showPreview = false
    
    func disableAll() {
        torchIsOn = false
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack {
                Button(action: { disableAll(); viewModel.resetInputBook() }, label: { Text("Annulla") })
                Spacer()
                Button(action: { disableAll() }, label: { Text("Conferma") }).disabled(showPreview == false || viewModel.notFound)
            }.padding(.horizontal).padding(.top)

            TextField("ISBN", text: $viewModel.inputBook.ISBN, onEditingChanged: { changed in
                if (!changed) {
                    viewModel.getBookDataFromISBN(isbn: viewModel.inputBook.ISBN)
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal).keyboardType(.numberPad)
            
            ZStack {
                CBScanner(
                    supportBarcode: .constant([.ean13]),
                    torchLightIsOn: $torchIsOn,
                    scanInterval: .constant(3.0)
                ){ result in
                    if (result.value != viewModel.inputBook.ISBN) {
                        viewModel.getBookDataFromISBN(isbn: result.value)                        
                    }
                    showPreview = true
                }
                onDraw: {
                    let lineWidth = 2
                    let lineColor = UIColor.red
                    let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)
                    $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
                }
                
                VStack {
                    if (showPreview) {
                        HStack {
                            Spacer()
                            if (viewModel.notFound) {
                                VStack {
                                    Text("Nessun risultato trovato").font(.title2)
                                    Text("L'ISBN inserito non esiste o non è presente nel database di Google Books")
                                }
                            } else {
                                HStack {
                                    Spacer()
                                    if viewModel.inputBook.cover != nil {
                                        Image(uiImage: viewModel.inputBook.cover!).resizable().scaledToFit().frame(width: 50, height: 100)
                                    }
                                    Spacer()
                                    if (viewModel.inputBook.title != "") {
                                        Text(viewModel.inputBook.title).font(.title2)
                                    }
                                    if (viewModel.inputBook.author != "") {
                                        Text(" - ")
                                        Text(viewModel.inputBook.author)
                                    }
                                    Spacer()
                                }
                            }
                            Spacer()
                        }.background(Color(UIColor.systemBackground).opacity(0.5))
                    }
                    Spacer()
                }
                
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
            
        }
    }
}
