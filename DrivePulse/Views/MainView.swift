//
//  MainView.swift
//  DrivePulse
//
//  Created by Linir Zamir on 10/4/23.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State private var buttonText = "Tap me"

    var body: some View {
        VStack{
            Image("img-vehicle")
                .padding(.bottom, 70)

            VStack {
                VStack(alignment: .center, spacing: 0) {
                    Text("DrivePulse:")
                        .font(.custom("Poppins-SemiBold", size: 35))
                    
                    Text("Control Your Drive")
                        .font(.custom("Poppins-SemiBold", size: 35))
                }
                .padding(.bottom, 40)
    
                Text("Analyze, Score, and Improve Your Driving in Real Time")
                    .font(.custom("Poppins-SemiBold", size: 14))
            }
            
            HStack{
                Image("ic-login")
                
                Image("ic-register")
            }
        }
    }
}
