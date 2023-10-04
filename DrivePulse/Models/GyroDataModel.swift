//
//  GyroDataModel.swift
//  DrivePulse
//
//  Created by Linir Zamir on 9/27/23.
//

import Foundation
import SwiftUI
import Combine

enum DetectedEvent {
    case hardBrake
    // Add more events as needed
}

class GyroDataModel: ObservableObject {
    
    // Published properties will trigger UI update when modified
    @Published var gyroData: (x: Int, y: Int, z: Int) = (0, 0, 0)
    @Published var eventDetected: DetectedEvent? {
        didSet {
            print("Event detected changed: \(String(describing: eventDetected))")
        }
    }
    
    init() {
        // Initialization if needed
    }
    
    func calculateMagnitude(accelData: (Int, Int, Int)) -> Double {
        let magnitude = sqrt(Double(accelData.0 * accelData.0 + accelData.1 * accelData.1 + accelData.2 * accelData.2))
        return magnitude
    }

    
    // Function to reset event after it has been processed
    func resetEvent() {
        eventDetected = nil
    }
}
