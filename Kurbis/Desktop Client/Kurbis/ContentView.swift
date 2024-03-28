//
//  ContentView.swift
//  Kurbis
//
//  Created by Baptiste Bohelay on 19/11/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var calibrationManager = CalibrationManager.shared

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
                    .background(calibrationManager.isCalibrating ? Color.gray : Color.blue)
                    .cornerRadius(40)
            }
            .disabled(calibrationManager.isCalibrating)
            .padding()
            
            // Level Meter UI
            VStack {
                Text("Microphone Level")
                ProgressView(value: calibrationManager.microphoneSignalLevel)
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .scaleEffect(x: 1, y: 2, anchor: .center) // Increase thickness of the progress bar
            }
            .padding()
        }
        .padding()
    }
}
