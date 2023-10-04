import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var driver: Driver?
    var apiController = APIController()
    var authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        if let driverId = authViewModel.driverId {
            loadDriverDetails(driverId: driverId)
        }
    }
    
    func loadDriverDetails(driverId: Int) {
        apiController.fetchDriverDetails(driverId: driverId) { [weak self] driver in
            DispatchQueue.main.async {
                self?.driver = driver
            }
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Header with user profile information
                HStack {
                    // Placeholder user image, replace with actual user profile image
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        if let driver = viewModel.driver {
                            Text("\(driver.first_name) \(driver.last_name)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("Driver ID: \(driver.id)")
                            Text("Email: \(driver.email)") // Email
                            Text("License Number: \(driver.driver_license_number)") // Driver license number
                        }
                    }
                    Spacer()
                }

                // Update Account Information Button
                Button(action: { /* Update account info action */ }) {
                    Text("Update Account Information")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding([.top, .bottom])

                // Separator Line
                Divider().background(Color.gray.opacity(0.7))

                // Device UUID Section
                HStack {
                    Image(systemName: "iphone") // Placeholder device icon, replace with actual user's device image
                        .resizable()
                        .frame(width: 30, height: 30)
                    if let driver = viewModel.driver {
                            Text("Device UUID: \(driver.device_uuid)") // Device UUID
                        }
                }
                .padding(.top)
                
                // App Preferences
                Text("App Preferences")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // App Preferences Section

                // Logout Button
                Button(action: {
                    authViewModel.logout()
                }) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        Text("Logout")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 2)
                    )
                }
                .padding([.top, .bottom])

            }
            .padding()
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}
