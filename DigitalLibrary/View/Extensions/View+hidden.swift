//
//  View+HiddenToggle.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 20/06/21.
//

import SwiftUI

extension View {
    func hidden(_ isHidden: Bool) -> some View {
        opacity(isHidden ? 0 : 1)
    }
}
