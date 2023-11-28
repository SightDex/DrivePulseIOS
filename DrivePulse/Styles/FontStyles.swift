//
//  FontStyles.swift
//  DrivePulse
//
//  Created by Linir Zamir on 10/5/23.
//

import Foundation
import SwiftUI

extension Font {
    
    static var MainTitle: Font {
        
        return Font.custom("Poppins-SemiBold", size: 35)
    }
    
    static var SemiTitle: Font {
        
        return Font.custom("Poppins-Regular", size: 14)
    }
    
    static var LoginTitle: Font {
        
        return Font.custom("Poppins-Bold", size: 30)
    }
    
    static var LoginSemiTitle: Font {
        
        return Font.custom("Poppins-SemiBold", size: 20)
    }
    
    static var poppins_semibold_20: Font {
        
        return Font.custom("Poppins-SemiBold", size: 20)
    }
    
    static var poppins_semibold_14: Font {
        
        return Font.custom("Poppins-SemiBold", size: 14)
    }
    
    static var poppins_medium_14: Font {
        
        return Font.custom("Poppins-Medium", size: 14)
    }
    
    static var TextInput: Font {
        
        return Font.custom("Poppins-Medium", size: 16)
    }

   
}
