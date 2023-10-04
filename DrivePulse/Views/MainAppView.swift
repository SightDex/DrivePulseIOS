//
//  MainAppView.swift
//  DrivePulse
//
//  Created by Linir Zamir on 9/25/23.
//

import Foundation
import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            if authViewModel.isAuthenticated {
                TestPageView()
            } else {
                LoginView()
            }
        }
    }
}
