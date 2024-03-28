//
//  Calibration.swift
//  Kurbis
//
//  Created by Baptiste Bohelay on 28/03/2024.
//

import Foundation

class CalibrationManager: ObservableObject {
    
    static let shared = CalibrationManager()
    var bluetoothConnector = BluetoothConnector.shared
    
    // Use @Published for properties that, when changed, should update the UI
    @Published var isCalibrating = false
    @Published var microphoneSignalLevel: Double = 0.0 // Represents signal level, 0.0 to 1.0 for simplicity

    // Your existing methods here...
    func updateMicrophoneSignalLevel(newLevel: Double) {
        self.microphoneSignalLevel = newLevel
        // Additional logic to handle the new level
    }
    
    func startCalibration() {
        // Start the calibration process
        isCalibrating = true
        
        bluetoothConnector.sendMessage("calistart");
        
        // Example calibration process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Assume calibration takes 2 seconds, then:
            self.isCalibrating = false
            print("Calibration completed")
        }
    }
}

