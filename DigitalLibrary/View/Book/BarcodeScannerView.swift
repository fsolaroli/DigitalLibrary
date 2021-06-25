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
    @State var ISBN = ""
    
    func disableAll() {
        torchIsOn = false
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack {
                Button(action: { disableAll() }, label: { Text("Annulla") })
                Spacer()
                Button(
                    action: {
                        disableAll()
                        viewModel.getBookDataFromISBN(isbn: ISBN)
                    },
                    label: { Text("Conferma") })
            }.padding(.horizontal).padding(.top)

            TextField("ISBN", text: $ISBN).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal).keyboardType(.numberPad)
            
            ZStack {
                CBScanner(
                    supportBarcode: .constant([.ean13]),
                    torchLightIsOn: $torchIsOn,
                    scanInterval: .constant(1.0)
                ){ result in
                    ISBN = result.value
                }
                onDraw: {
                    let lineWidth = 2
                    let lineColor = UIColor.red
                    let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)
                    $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
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
