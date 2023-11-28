import SwiftUI

struct LiveDataView: View {
    
    // Observe the GyroDataModel
    @ObservedObject var gyroDataModel: GyroDataModel
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Title and Explanation
            Text("Live Data")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Real-time gyroscopic data and detected driving events are displayed below.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Gyro Data Display
            GroupBox(label:
                Label("Gyro Data", systemImage: "g.circle").padding(.bottom, 10)) { // Added bottom padding here
                HStack(alignment: .center) {
                    VStack {
                        Image(systemName: "arrow.turn.down.left")
                        Text("X: \(gyroDataModel.gyroData.x)")
                            .padding()
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "arrow.forward.square")
                        Text("Y: \(gyroDataModel.gyroData.y)")
                            .padding()
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "arrow.turn.down.right")
                        Text("Z: \(gyroDataModel.gyroData.z)")
                            .padding()
                    }
                }
            }
            .padding()
            
            // Detected Events
            if let event = gyroDataModel.eventDetected {
                VStack {
                    Text("Detected Event")
                        .font(.headline)
                    Text(event == .hardBrake ? "Hard Brake Detected" : "")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
                .scaleEffect(1)
                .opacity(1)
                .animation(
                    Animation.easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                )
            }
        }
        .padding()
        .navigationBarTitle("Live Data", displayMode: .inline)
    }
}
