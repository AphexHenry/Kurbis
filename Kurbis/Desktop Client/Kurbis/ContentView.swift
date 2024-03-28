//
//  ContentView.swift
//  Kurbis
//
//  Created by Baptiste Bohelay on 19/11/2023.
//

import SwiftUI

struct ContentView: View {
    // Observe changes in CalibrationManager
    @StateObject private var calibrationManager = CalibrationManager()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
            Button(action: {
                // Trigger calibration
                calibrationManager.startCalibration()
            }) {
                Text("Start Calibration")
                    .fontWeight(.semibold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(calibrationManager.isCalibrating ? Color.gray : Color.blue) // Change button color based on calibration state
                    .cornerRadius(40)
            }
            .disabled(calibrationManager.isCalibrating) // Disable button during calibration
            .padding()
        }
        .padding()
    }
}
