import Foundation
import Security

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var username: String?
    @Published var driverId: Int?
    
    init() {
        if let credentials = retrieveCredentials() {
            print("Init method: Retrieved credentials for \(credentials.username)")
            isLoggedIn = true
            self.username = credentials.username
            self.driverId = credentials.driverId
        }
    }

    
    func storeDriverId(driverId: Int) {
        let driverIdData = "\(driverId)".data(using: String.Encoding.utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "DriverId",
            kSecValueData as String: driverIdData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("Driver ID stored successfully.")
        } else {
            print("Failed to store Driver ID with OSStatus: \(status)")
        }
    }

    func retrieveDriverId() -> Int? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "DriverId",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var retrievedData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &retrievedData)

        if status != errSecSuccess {
            print("retrieveDriverId failed with OSStatus: \(status)")  // Debug
            return nil
        }

        if let data = retrievedData as? Data,
           let driverIdString = String(data: data, encoding: String.Encoding.utf8),
           let driverId = Int(driverIdString) {
            return driverId
        }
        
        return nil
    }

    
    // Login
    func login(username: String, password: String) {
        isLoading = true
        
        // Create your login request
        let url = URL(string: "https://drivepulse.sightdex.com/api/driver-app-login/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let body: [String: Any] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                guard let data = data, error == nil else {
                    print("Something went wrong")
                    return
                }

                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDict = json as? [String: Any], let status = jsonDict["status"] as? String {
                    if status == "success" {
                        print(jsonDict)
                        self.isLoggedIn = true
                        self.username = username
                        if let driverId = jsonDict["driverId"] as? Int {
                            self.driverId = driverId
                            self.storeCredentials(username: username, password: password, driverId: driverId)  // Store the credentials
                        }
                        
                    } else {
                        self.isLoggedIn = false
                        // You can also set an error message to display to the user
                    }
                }
            }
        }.resume()
    }

        
    func register(username: String, password: String, firstName: String, lastName: String, driverLicense: String, email: String, dob: Date) {
        isLoading = true
        
        // Define the URL for registration. Replace with your actual Django API URL.
        let url = URL(string: "https://drivepulse.sightdex.com/api/driver-app-register/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: dob)
        
        // Set the content type to JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the body data. You may need to add more fields based on your Django model.
        let body: [String: Any] = [
            "username": username,
            "password": password,
            "firstName": firstName,
            "lastName": lastName,
            "driverLicense": driverLicense,
            "email": email,
            "dob": formattedDate
        ]
        
        // Convert the body data to JSON
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Make the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                // Error handling
                guard let data = data, error == nil else {
                    print("Something went wrong: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // Parse the JSON response
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDict = json as? [String: Any], jsonDict["status"] as? String == "success" {
                    self.isLoggedIn = true
                    self.username = username
                    if let driverId = jsonDict["driverId"] as? Int {
                        self.driverId = driverId
                        self.storeCredentials(username: username, password: password, driverId: driverId)
                    }
                    print("Registration successful")
                } else {
                    print("Registration failed")
                }
            }
        }.resume()
    }

    
    // Logout and clear saved credentials
    func logout() {
        isLoggedIn = false
        self.username = nil
    }
    
    // Keychain Helper Methods
    func storeCredentials(username: String, password: String, driverId: Int) {
        let credentialsData = "\(username):\(password):\(driverId)".data(using: String.Encoding.utf8)!

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                     kSecAttrAccount as String: "DrivePulseCredentials",
                                     kSecValueData as String: credentialsData,
                                     kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked]

        // Try to update the existing keychain item
        let statusUpdate = SecItemUpdate(query as CFDictionary, [kSecValueData as String: credentialsData] as CFDictionary)

        if statusUpdate == errSecSuccess {
            print("Credentials updated successfully.")
        } else if statusUpdate == errSecItemNotFound {
            // If the item doesn't exist, add it to the keychain
            let statusAdd = SecItemAdd(query as CFDictionary, nil)
            if statusAdd == errSecSuccess {
                print("Credentials stored successfully.")
            } else {
                print("Failed to store credentials with OSStatus: \(statusAdd)")
            }
        } else {
            print("Failed to update credentials with OSStatus: \(statusUpdate)")
        }

        // Immediate retrieval for debug
        if let retrievedCredentials = retrieveCredentials() {
            print("Immediately retrieved credentials: \(retrievedCredentials)")
        } else {
            print("Failed to immediately retrieve credentials.")
        }
    }


    func retrieveCredentials() -> (username: String, password: String, driverId: Int)? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                     kSecAttrAccount as String: "DrivePulseCredentials",
                                     kSecReturnData as String: kCFBooleanTrue!,
                                     kSecMatchLimit as String: kSecMatchLimitOne]
        
        var retrievedData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &retrievedData)

        if status != errSecSuccess {
                print("retrieveCredentials failed with OSStatus: \(status)")  // Debug
                return nil
            }
    
        if let data = retrievedData as? Data,
           let credentialsString = String(data: data, encoding: String.Encoding.utf8) {
            let credentialsArray = credentialsString.components(separatedBy: ":")
            if credentialsArray.count == 3, let driverId = Int(credentialsArray[2]) {
                return (username: credentialsArray[0], password: credentialsArray[1], driverId: driverId)
            }
        }
        
        return nil
    }
}
