//
//  IndexView.swift
//  DrivePulse
//
//  Created by Linir Zamir on 10/4/23.
//

import Foundation
import SwiftUI

struct IndexView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack{
            Image("img-vehicle")
                .padding(.top, 100)

            VStack {
                VStack{
                    Text("DrivePulse")
                        .font(.MainTitle)
                        .foregroundColor(Color.accentColor)

                    Text("Control Your Drive")
                        .font(.MainTitle)
                        .foregroundColor(Color.accentColor)
                }
                .padding(.bottom, 23)
                
                VStack{
                    Text("Analyze, Score, and Improve Your\nDriving in Real Time")
                        .font(.SemiTitle)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

               }
            }
            .padding(.bottom, 88)
            .padding(.horizontal, 30)
            
            HStack(spacing: 30){
                NavigationLink(destination: LoginView().environmentObject(authViewModel)) {
                    Text("Login")
                        .font(.poppins_semibold_20)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                NavigationLink(destination: RegistrationView().environmentObject(authViewModel)) {
                    Text("Register")
                        .font(.poppins_semibold_20)
                        .foregroundColor(Color.accentColor)
                        .padding()
                        .frame(maxWidth: .infinity)

                }
            }
            .padding(.bottom, 94)
            .padding(.horizontal, 40)
        }
    }
}
