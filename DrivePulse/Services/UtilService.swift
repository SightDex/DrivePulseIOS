//
//  UtilService.swift
//  DrivePulse
//
//  Created by Linir Zamir on 9/25/23.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        
        let red = CGFloat((int >> 16) & 0xFF) / 255
        let green = CGFloat((int >> 8) & 0xFF) / 255
        let blue = CGFloat(int & 0xFF) / 255
        
        self.init(
            .sRGB,
            red: red, green: green, blue: blue, opacity: 1
        )
    }
}
