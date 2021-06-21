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
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var torchIsOn = false
    @State var ISBN = ""
    
    func disableAll() {
        torchIsOn = false
        UIApplication.shared.endEditing()
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
                }
//                .disabled(!showCodebarScanner && showCoverScanner)
                
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
