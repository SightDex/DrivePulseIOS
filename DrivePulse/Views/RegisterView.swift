//
//  RegisterView.swift
//  DrivePulse
//
//  Created by Linir Zamir on 9/25/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var driverLicense: String = ""
    @State private var email: String = ""
    @State private var dob: Date = Date()
    @State private var profileImage: Image? = Image("defaultProfileImage") // Default image
    @State private var isImagePickerPresented: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            // Single Background Color
            Color(hex: "A2D4F2")
                .ignoresSafeArea()
            
            VStack {
                // Welcome Text and Description
                Text("Welcome to DrivePulse")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                Text("Your journey to safer driving starts here.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 30)
                
                // All Text Fields
                VStack(spacing: 20) {
                    TextField("First Name", text: $firstName)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Last Name", text: $lastName)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Driver License", text: $driverLicense)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Email", text: $email)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                        .padding(.horizontal)
                    
                    TextField("Username", text: $username)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Password", text: $password)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // Register Button
                Button(action: {
                    authViewModel.register(
                        username: username,
                        password: password,
                        firstName: firstName,
                        lastName: lastName,
                        driverLicense: driverLicense,
                        email: email,
                        dob: dob
                    )
                }) {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color(hex: "49ABE6"))
                        .cornerRadius(15.0)
                        .shadow(radius: 10)
                }
                .padding(.top, 20)
                
                // Additional Info
                Text("By registering, you agree to our Terms & Conditions and Privacy Policy.")
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
