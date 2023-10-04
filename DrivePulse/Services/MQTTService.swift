//
//  MQTTService.swift
//  DrivePulse
//
//  Created by Linir Zamir on 9/25/23.
//

import Foundation
import CocoaMQTT

// Define constants for topics
enum MQTTopics: String {
    case driverBehavior = "driver/behavior"
    case accidents = "events/accidents"
    case vehicleInfo = "vehicle/info"
    case deviceHealth = "device/health"
}


// Define the MQTTService class
class MQTTService: NSObject {
    static let shared = MQTTService()  // Singleton instance
    private var mqtt: CocoaMQTT?
    
    // Initialize and connect to the MQTT broker
    func connect() {
        mqtt = CocoaMQTT(clientID: "iOS Device", host: "3.22.55.204", port: 1883)
        
        // Set up the closure-based handlers here
        mqtt?.didConnectAck = { mqtt, ack in
            if ack == .accept {
                mqtt.subscribe(MQTTopics.driverBehavior.rawValue)
                mqtt.subscribe(MQTTopics.accidents.rawValue)
                mqtt.subscribe(MQTTopics.vehicleInfo.rawValue)
                mqtt.subscribe(MQTTopics.deviceHealth.rawValue)
            }
        }
        
        mqtt?.didPublishMessage = { mqtt, message, id in
            print("Message published to topic \(message.topic) with payload \(message.string ?? "") and ID \(id)")
        }

        mqtt?.didPublishAck = { mqtt, id in
            // Implement as needed
        }
        
        mqtt?.didReceiveMessage = { mqtt, message, id in
            // Implement as needed
        }
        
        mqtt?.didPing = { mqtt in
            // Implement as needed
        }
        
        mqtt?.didReceivePong = { mqtt in
            // Implement as needed
        }
        
        mqtt?.didDisconnect = { mqtt, err in
            // Implement as needed
        }
        
        mqtt?.connect()  // Removed the capture of the return value
    }
    
    func publishDriverBehavior(gyroData: (Int, Int, Int), drivingData: [String: Any]) {
        publishData(to: .driverBehavior, gyroData: gyroData, drivingData: drivingData)
    }

    func publishAccidentData(data: [String: Any]) {
        publishData(to: .accidents, gyroData: (0,0,0), drivingData: data) // Use actual gyroData
    }
    
    // Publish gyro and driving data to a specified topic
    func publishData(to topic: MQTTopics, gyroData: (Int, Int, Int), drivingData: [String: Any], eventType: String? = nil) {
        print("publishDrivingData called")
        guard let mqtt = self.mqtt else {
            print("MQTT not connected")
            return
        }
        
        var payload: [String: Any] = [
            "gyroData": [
                "x": gyroData.0,
                "y": gyroData.1,
                "z": gyroData.2
            ]
        ]
    
        // Include the event type if available
        if let eventType = eventType {
            payload["eventType"] = eventType
        }
    
        for (key, value) in drivingData {
            payload[key] = value
        }
        
        if let data = try? JSONSerialization.data(withJSONObject: payload, options: []),
           let string = String(data: data, encoding: .utf8) {
            mqtt.publish(topic.rawValue, withString: string, qos: .qos1)
        }
    }
}
