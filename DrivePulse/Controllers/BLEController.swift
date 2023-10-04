//
//  BLEController.swift
//  DrivePulse
//
//  Created by Linir Zamir on 9/27/23.
//

import Foundation
import CoreBluetooth


class BLEController: BluetoothServiceDelegate {

    // Bluetooth Service instance
    private var bluetoothService: BluetoothService

    // Gyro Data Model
    var gyroDataModel: GyroDataModel
    
    // Initialize MQTTService
    private let mqttService = MQTTService.shared

    // Bluetooth UUID
    private var bluetoothUUID: String?
    
    init(gyroDataModel: GyroDataModel) {
        self.gyroDataModel = gyroDataModel
        self.bluetoothService = BluetoothService()
        bluetoothService.delegate = self

        // Connect to MQTT broker
        mqttService.connect()
    }
    
    func didConnectToDevice(uuid: String) {
        self.bluetoothUUID = uuid
    }
    
    // Extract movement data similar to your Python code
    func extractMovementData(data: Data) -> (gyro: (Int, Int, Int), accel: (Int, Int, Int)) {
        let dataArray = [UInt8](data)
        
        // Ensure we have at least 12 bytes of data to read
        guard dataArray.count >= 12 else {
            return ((0, 0, 0), (0, 0, 0))
        }
        
        // Unpack the first 12 bytes into gyro and accel data
        let gyroX = Int(Int16(dataArray[0]) | Int16(dataArray[1]) << 8)
        let gyroY = Int(Int16(dataArray[2]) | Int16(dataArray[3]) << 8)
        let gyroZ = Int(Int16(dataArray[4]) | Int16(dataArray[5]) << 8)
        
        let accelX = Int(Int16(dataArray[6]) | Int16(dataArray[7]) << 8)
        let accelY = Int(Int16(dataArray[8]) | Int16(dataArray[9]) << 8)
        let accelZ = Int(Int16(dataArray[10]) | Int16(dataArray[11]) << 8)
        
        return ((gyroX, gyroY, gyroZ), (accelX, accelY, accelZ))
    }

    
    // Detect events like "hard brakes" based on your Python code
    func detectEvent(gyroData: (Int, Int, Int), accelData: (Int, Int, Int)) -> Bool {
        // If an event is already detected, do nothing
        guard gyroDataModel.eventDetected == nil else {
            return false
        }

        let magnitude = gyroDataModel.calculateMagnitude(accelData: accelData)
        let hardBrakeThreshold: Double = 20000.0  // Placeholder value

        if magnitude > hardBrakeThreshold {
            // Detected a "hard brake" event
            gyroDataModel.eventDetected = .hardBrake

            // Reset the event after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.gyroDataModel.resetEvent()
            }
            
            return true
        }

        // Update gyro data
        gyroDataModel.gyroData = gyroData

        return false
    }



    func didReceiveData(_ data: Data) {
        let (gyroData, accelData) = extractMovementData(data: data)
        let newEventDetected = detectEvent(gyroData: gyroData, accelData: accelData)

        // Prepare the data to send to MQTT broker
        let drivingData: [String: Any] = [
            "device_uuid": bluetoothUUID ?? "Unknown",
            // More driver-specific data here
        ]
        
        if newEventDetected && gyroDataModel.eventDetected == .hardBrake {
            mqttService.publishData(to: .accidents, gyroData: gyroData, drivingData: drivingData, eventType: "Hard Brake")
        }
    }
}

