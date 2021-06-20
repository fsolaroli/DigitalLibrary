//
//  UIApplication+endEditing.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 20/06/21.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
