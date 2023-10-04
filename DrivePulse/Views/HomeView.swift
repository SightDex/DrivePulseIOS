import SwiftUI

struct HelpView: View {
    @Binding var isPresented: Bool  // Use a binding to control visibility

    var body: some View {
        VStack {
            Text("What is DrivePulse?")
                .font(.headline)
            
            Text("DrivePulse is designed to provide real-time insights into your driving behavior. It helps to enhance safety and efficiency on the road.")
                .multilineTextAlignment(.leading)
                .padding()
            
            Button("Close") {
                isPresented = false  // Close the popup
            }
        }
        .padding()
    }
}

import SwiftUI

// Helper View for Progress Row
struct ProgressRow: View {
    var title: String
    var value: Float
    var total: Float

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)

            ProgressView(value: value, total: total)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))

            Text("\(String(format: "%.0f", value)) / \(Int(total))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}


struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    @State private var showingHelpSheet = false  // For Help popup

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Section
                ZStack {
                    Color.blue.opacity(0.1)
                        .cornerRadius(10)
                    
                    VStack {
                        VStack(alignment: .center) {
                            Image(systemName: "car.2")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .foregroundColor(.blue)
                            
                            Text("Welcome to DrivePulse")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 20)
                        
                        Text("DrivePulse provides real-time insights into your driving behavior, helping to enhance safety and efficiency on the road.")
                            .padding([.horizontal, .bottom])
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }
                }
                .padding([.horizontal, .bottom])
                
                // Driver Information Card
                VStack(alignment: .leading, spacing: 15) {
                    Text("Driver Information")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    if let driver = settingsViewModel.driver {
                        Text("Risk-O-Meter: \(driver.risk_o_meter)")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        let totalScoreValue = Float(driver.score) ?? 0.0
                        ProgressRow(title: "Total Score", value: totalScoreValue, total: 100.0)
                    } else {
                        Text("Loading driver information...")
                            .foregroundColor(.gray)
                    }

                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Additional Information
                VStack {
                    Text("Navigate to other tabs to view live data, event history, or adjust settings.")
                        .padding([.horizontal, .bottom])
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        // Implement your button action here
                    }) {
                        Text("Explore Features")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding([.horizontal, .bottom])
                
                // Onboarding Pop-Up Placeholder
                // Consider showing this only when the user first opens the app
                Text("First time here? Tap here to see how it works!")
                    .underline()
                    .foregroundColor(.blue)
                    .onTapGesture {
                        showingHelpSheet.toggle()  // Toggle the state to show Help popup
                    }
                    .sheet(isPresented: $showingHelpSheet) {
                        HelpView(isPresented: $showingHelpSheet)  // Pass the binding
                    }
                
                Spacer()  // Pushes content to the top
            }
        }
        .padding(.bottom, 20)
        .onAppear {
            settingsViewModel.loadDriverDetails(driverId: authViewModel.driverId ?? 0)  // Trigger a refresh
        }
    }
}


// Helper View for Information Row
struct InformationRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text("\(title): \(value)")
        }
        .font(.subheadline)
    }
}
