//
//  String+searchFormat.swift
//  DigitalLibrary
//
//  Created by Fabio Solaroli on 27/06/21.
//

import Foundation

extension String {
    func searchFormat() -> String {
        return self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
