import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            // Background Gradient
            Color(hex: "A2D4F2")
                .ignoresSafeArea()
            
            VStack {
                // Welcome Text and Description
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                Text("Log in to continue")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 30)
                
                // Logo
                Image("DrivePulseLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 50)
                    .shadow(radius: 10)
                
                // Username and Password Fields
                VStack(spacing: 0) {
                    TextField("Username", text: $username)
                        .padding(.horizontal)
                        .font(.title3)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.continue)
                        .disableAutocorrection(true)
                        .padding(.bottom, 20)

                    SecureField("Password", text: $password)
                        .padding(.horizontal)
                        .font(.title3)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                }
                                
                // Login Button
                Button(action: {
                    authViewModel.login(username: username, password: password)
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color(hex: "49ABE6"))
                        .cornerRadius(15.0)
                        .shadow(radius: 10)
                }
                .padding(.top, 20)
                
                // Register Text
                NavigationLink(destination: RegistrationView().environmentObject(authViewModel)) {
                    Text("Don't have an account? Register")
                        .underline()
                        .padding(.top, 20)
                }
                
                // Additional Info or Disclaimer
                Text("By logging in, you agree to our Terms & Conditions.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
            }
            .padding(.horizontal, 27.5)
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}
