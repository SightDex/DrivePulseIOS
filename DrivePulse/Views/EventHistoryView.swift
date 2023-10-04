import SwiftUI
import Combine

// Dummy data model for an event
struct DrivingEvent: Identifiable, Decodable {
    var id: Int
    var eventType: String
    var timestamp: String
    var description: String
    var gyroData: [String: Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventType = "event_type"
        case timestamp
        case description = "ai_analysis"
        case gyroData = "gyro_data"
    }
    
    var formattedTimestamp: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        guard let date = dateFormatter.date(from: timestamp) else {
            return timestamp  // Return original string if parsing fails
        }
        dateFormatter.dateFormat = "MMM dd, yyyy, h:mm a"
        return dateFormatter.string(from: date)
    }
    
    var eventIcon: Image {
        switch eventType {
        case "Hard Brake":
            return Image(systemName: "exclamationmark.triangle.fill")
        // ... other cases for different event types
        default:
            return Image(systemName: "questionmark.circle.fill")
        }
    }
}


class EventHistoryViewModel: ObservableObject {
    @Published var driveEvents: [DrivingEvent] = []
    @Published var totalEvents: Int = 0
    @Published var hardBrakeEvents: Int = 0

    
    var apiController = APIController()
    var authViewModel: AuthViewModel

    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        if let driverId = authViewModel.driverId {
            print("Driver ID is: \(driverId)")  // Logging driverId
            loadEvents(driverId: driverId)
        } else {
            print("Driver ID is nil")  // Logging if driverId is nil
        }
    }

    func loadEvents(driverId: Int) {
        apiController.fetchDriveEvents(driverId: driverId) { [weak self] events in
            DispatchQueue.main.async {
                        if let newEvents = events?.reversed() {
                            self?.driveEvents = Array(newEvents)
                            
                            // Update counters
                            self?.totalEvents = newEvents.count
                            self?.hardBrakeEvents = newEvents.filter { $0.eventType == "Hard Brake" }.count
                            // ... counts for other event types...
                            
                        } else {
                            self?.driveEvents = []
                            
                            // Reset counter values
                            self?.totalEvents = 0
                            self?.hardBrakeEvents = 0
                            // ...
                        }
                    }
        }
    }

    
    func refresh() {
            if let driverId = authViewModel.driverId {
                print("Refreshing data for Driver ID: \(driverId)")
                loadEvents(driverId: driverId)
            } else {
                print("Driver ID is nil")
            }
        }
    
}

struct EventHistoryView: View {
    @EnvironmentObject var viewModel: EventHistoryViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Summary Section
                CardView {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        VStack(alignment: .leading) {
                            Text("Total Events:")
                            Text("\(viewModel.totalEvents)")
                        }
                        Spacer()
                        
                        Image(systemName: "car.fill")
                        VStack(alignment: .leading) {
                            Text("Hard Brakes: ")
                            Text("\(viewModel.hardBrakeEvents)")
                        }
                        Spacer()
                        
                        // Add more event types...
                    }
                    .font(.headline)
                }

                // List of Events
                ForEach(viewModel.driveEvents) { event in
                    Divider()

                    HStack {
                        event.eventIcon
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(event.eventType)
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Timestamp: \(event.formattedTimestamp)")
                            Text("Gyro Data: \(event.gyroData["x"] ?? 0), \(event.gyroData["y"] ?? 0), \(event.gyroData["z"] ?? 0)")
                            Text(event.description.isEmpty ? "No additional information" : event.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 10)
                    }
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
            .padding()
            .navigationBarTitle("Event History", displayMode: .inline)
        }
        .onAppear {
            viewModel.refresh()  // Call the new refresh function
        }
    }
}

// CardView for modern-looking cards
struct CardView<Content>: View where Content: View {
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, content: content)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
    }
    
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
}
