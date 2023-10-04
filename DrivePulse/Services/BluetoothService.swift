//
//  BluetoothService.swift
//  DrivePulse
//
//  Created by Linir Zamir on 9/25/23.
//
import CoreBluetooth

protocol BluetoothServiceDelegate {
    func didReceiveData(_ data: Data)
    func didConnectToDevice(uuid: String)
    // Add other delegate methods as needed
}

class BluetoothService: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var delegate: BluetoothServiceDelegate?

    // Core Bluetooth Manager
    private var centralManager: CBCentralManager!
    
    // Peripheral (CC2650)
    private var cc2650Peripheral: CBPeripheral?
    
    // UUID of the test unit
    let testUnitUUID = "B0:B4:48:D3:19:84"
    
    // Service and Characteristic UUIDs (Replace these with the actual UUIDs)
    let configUUID = CBUUID(string: "f000aa82-0451-4000-b000-000000000000")
    let dataUUID = CBUUID(string: "f000aa81-0451-4000-b000-000000000000")
    let serviceUUID = CBUUID(string: "F000AA80-0451-4000-B000-000000000000")

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central Manager state updated to: \(central.state)")
        switch central.state {
        case .poweredOn:
            // Start scanning for devices
            print("Bluetooth is powered on. Starting scan for peripherals.")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("Central Manager is in \(central.state) state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Here we filter peripherals by their UUID
        if peripheral.identifier.uuidString == "4CE08301-F059-05B8-74EB-3A4D86919284" {
            cc2650Peripheral = peripheral
            cc2650Peripheral?.delegate = self
            centralManager.stopScan()
            centralManager.connect(peripheral, options: nil)
            print("Attempting to connect to peripheral: \(peripheral.identifier.uuidString)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.identifier.uuidString)")
        delegate?.didConnectToDevice(uuid: testUnitUUID)
        peripheral.discoverServices([serviceUUID])
    }
    
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            if service.uuid == serviceUUID {
                peripheral.discoverCharacteristics([dataUUID, configUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            if characteristic.uuid == dataUUID {
                peripheral.setNotifyValue(true, for: characteristic)
            } else if characteristic.uuid == configUUID {
                let dataToWrite = Data([0xFF, 0xFF]) // Corresponding to [0xFF, 0xFF] in your Python code
                peripheral.writeValue(dataToWrite, for: characteristic, type: .withResponse)
            }
        }
    }

    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let data = characteristic.value {
            // Process the incoming gyro data
            print("Received raw data: \(data as NSData)")  // Casting to NSData for a more detailed byte print
            delegate?.didReceiveData(data)
        }
    }
    
}
