//
//  RegistrationView.swift
//  DrivePulse
//
//  Created by Linir Zamir on 10/5/23.
//

import Foundation
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
        VStack(spacing: 0) {
            HStack{
                ZStack(alignment: .topTrailing) {
                    Image("ic-bg1")
                    Image("ic-bg2")
                    
                    VStack {
                        Spacer()
                        HStack {
                            ZStack (alignment: .bottomLeading){
                                Image("ic-bg3")
                                Image("ic-bg4")
                            }
                            Spacer()
                        }
                    }
                    
                    VStack{
                        VStack{
                            Text("Welcome to DrivePulse")
                                .font(.LoginTitle)
                                .foregroundColor(Color("TitleColor"))
                                .padding(.bottom, 15)
                            
                            Text("Your journey to safer driving starts here")
                                .font(.poppins_medium_14)
                        }
                        .padding(.top, 135)
                        .padding(.bottom, 24)
                        
                        VStack(spacing: 10){
                            TextField("First Name", text: $firstName)
                                .font(.TextInput)
                                .submitLabel(.continue)
                                .disableAutocorrection(true)
                                .padding(12)
                                .background(Color("TextInputColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            TextField("Last Name", text: $lastName)
                                .font(.TextInput)
                                .submitLabel(.continue)
                                .disableAutocorrection(true)
                                .padding(12)
                                .background(Color("TextInputColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))

                            TextField("Driver License", text: $driverLicense)
                                .font(.TextInput)
                                .submitLabel(.continue)
                                .disableAutocorrection(true)
                                .padding(12)
                                .background(Color("TextInputColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            TextField("Email", text: $email)
                                .font(.TextInput)
                                .submitLabel(.continue)
                                .disableAutocorrection(true)
                                .padding(12)
                                .background(Color("TextInputColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                                .padding(12)

                            TextField("Username", text: $username)
                                .font(.TextInput)
                                .submitLabel(.continue)
                                .disableAutocorrection(true)
                                .padding(12)
                                .background(Color("TextInputColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            SecureField("Password", text: $password)
                                .font(.TextInput)
                                .submitLabel(.done)
                                .padding(12)
                                .background(Color("TextInputColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom, 30)
    
                            
                            
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
                                    .font(.poppins_semibold_20)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                            }
                            
                            Text("By registering, you agree to our Terms & Conditions and Privacy Policy.")
                                .font(.poppins_medium_14)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.top, 20)
                            
                        }
                        .padding(.horizontal, 35)
                        .padding(.bottom, 65)
                    }
                    .frame(maxWidth: .infinity)
                }
                .edgesIgnoringSafeArea(.all)
            }
        Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}
