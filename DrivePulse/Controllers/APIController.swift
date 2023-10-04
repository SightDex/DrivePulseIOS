// APIController.swift
import Foundation

struct Driver: Decodable {
    var id: Int
    var first_name: String
    var last_name: String
    var email: String
    var score: Int
    var device_uuid: String
    var driver_license_number: String
    var risk_o_meter: String
}


class APIController {
    
    func fetchDriveEvents(driverId: Int, completion: @escaping ([DrivingEvent]?) -> Void) {
        let urlString = "https://drivepulse.sightdex.com/api/drivers/\(driverId)/events/"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
                    
            do {
                let events = try JSONDecoder().decode([DrivingEvent].self, from: data)
                completion(events)
            } catch {
                print("Failed to decode JSON:", error)
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func fetchDriverDetails(driverId: Int, completion: @escaping (Driver?) -> Void) {
        let urlString = "https://drivepulse.sightdex.com/api/drivers/\(driverId)/"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
                    
            do {
                let driver = try JSONDecoder().decode(Driver.self, from: data)
                completion(driver)
            } catch {
                print("Failed to decode JSON:", error)
                completion(nil)
            }
        }
        
        task.resume()
    }

    
}
