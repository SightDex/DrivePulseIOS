//
//  ViewExtensions.swift
//  DrivePulse
//
//  Created by Linir Zamir on 9/25/23.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
