//
//  DrivePulseApp.swift
//  DrivePulse
//
//  Created by Linir Zamir on 9/25/23.
//

import SwiftUI

@main
struct DrivePulseApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var eventHistoryViewModel = EventHistoryViewModel(authViewModel: AuthViewModel())
    @StateObject var settingsViewModel = SettingsViewModel(authViewModel: AuthViewModel())  // Initialize here

    init() {
        MQTTService.shared.connect()
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if authViewModel.isLoggedIn {
                    DashboardView()
                        .environmentObject(authViewModel)
                        .environmentObject(eventHistoryViewModel) // Pass down
                        .environmentObject(settingsViewModel) // Pass down the new ViewModel
                } else {
                    MainView()
                        .environmentObject(authViewModel)
                }
            }
            .environment(\.colorScheme, .light)
        }
    }
}
