//
//  LoginView_tmp.swift
//  DrivePulse
//
//  Created by Linir Zamir on 10/5/23.
//

import Foundation
import SwiftUI

struct LoginView_tmp: View {
    @State private var username: String = ""
    @State private var password: String = ""
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
                            Text("Welcome Back!")
                                .font(.LoginTitle)
                                .foregroundColor(Color("TitleColor"))
                            Text("Log in to continue")
                                .font(.LoginSemiTitle)
                                .padding(.top, 26)
                        }
                        .padding(.top, 120)
                        .padding(.bottom, 75)
                        
                        VStack{
                            TextField("Username", text: $username)
                                .font(.TextInput)
                                .submitLabel(.continue)
                                .disableAutocorrection(true)
                                .padding()
                                .background(Color("TextInputColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom, 20)
                            
                            SecureField("Password", text: $password)
                                .font(.TextInput)
                                .submitLabel(.done)
                                .padding()
                                .background(Color("TextInputColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(.bottom, 30)
                            
                            Text("Forgot Your Password?")
                                .font(.poppins_semibold_14)
                                .foregroundColor(Color.accentColor)
                                .padding(.bottom, 10)
                            
                            Button(action: {
                                authViewModel.login(username: username, password: password)
                            }) {
                                Text("Sign In")
                                    .font(.poppins_semibold_20)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                            }
                            .padding(.bottom, 30)
                            
                            Text("Create New Account")
                                .font(.poppins_semibold_14)
                                .foregroundColor(Color("DarkGray"))
                            
                        }
                        .padding(.horizontal, 35)
                        .padding(.bottom, 65)
                        
                        VStack{
                            Text("Or Continue With")
                                .font(.poppins_semibold_14)
                                .foregroundColor(Color.accentColor)
                                .padding(.bottom, 10)
                            
                            HStack{
                                Image("ic-google")
                                Image("ic-facebook")
                                Image("ic-apple")

                            }
                        }
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
