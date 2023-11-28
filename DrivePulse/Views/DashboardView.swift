//
//  DashboardView.swift
//  DrivePulse
//
//  Created by Linir Zamir on 9/25/23.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var eventHistoryViewModel: EventHistoryViewModel // Retrieve here
    @EnvironmentObject var settingsViewModel: SettingsViewModel  // Add this line

    @StateObject var gyroDataModel = GyroDataModel()

    var body: some View {
        TabView {
            
            NavigationView {
                    HomeView()
                        .navigationBarTitle("Home", displayMode: .inline)
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                
                // Live Data Tab
                NavigationView {
                    LiveDataView(gyroDataModel: gyroDataModel)
                        .navigationBarTitle("Live Data", displayMode: .inline)
                }
                .tabItem {
                    Label("Live Data", systemImage: "waveform.path.ecg")
                }
            
                // Event History Tab
                NavigationView {
                    EventHistoryView(viewModel: _eventHistoryViewModel)  // Updated line
                        .navigationBarTitle("Event History", displayMode: .inline)
                }
                .tabItem {
                    Label("Event History", systemImage: "clock")
                }
            
                // Settings Tab
                NavigationView {
                    SettingsView(viewModel: settingsViewModel)  // Pass the environment object explicitly
                        .navigationBarTitle("Settings", displayMode: .inline)
                }
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                        
        }
        .onAppear {
            _ = BLEController(gyroDataModel: gyroDataModel)
        }
    }
}
