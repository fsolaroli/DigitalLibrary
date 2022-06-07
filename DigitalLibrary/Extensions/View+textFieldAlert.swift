//
//  View+textFieldAlert.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 07/06/22.
//

import SwiftUI

extension View {

    public func textFieldAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String = "",
        text: String = "",
        placeholder: String = "",
        accept: String = "OK",
        cancel: String? = "Annulla",
        action: @escaping (String?) -> Void
    ) -> some View {
        self.modifier(TextFieldAlertModifier(isPresented: isPresented, title: title, message: message, text: text, placeholder: placeholder, accept: accept, cancel: cancel, action: action))
    }
    
}
