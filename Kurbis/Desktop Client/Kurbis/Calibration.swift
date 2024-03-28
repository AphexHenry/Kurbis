//
//  Calibration.swift
//  Kurbis
//
//  Created by Baptiste Bohelay on 28/03/2024.
//

import Foundation

class CalibrationManager: ObservableObject {
    
    var bluetoothConnector = BluetoothConnector.shared
    
    // Use @Published for properties that, when changed, should update the UI
    @Published var isCalibrating = false
    
    func startCalibration() {
        // Start the calibration process
        isCalibrating = true
        
        bluetoothConnector.sendMessage("calibration started");
        
        // Example calibration process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Assume calibration takes 2 seconds, then:
            self.isCalibrating = false
            print("Calibration completed")
        }
    }
}

