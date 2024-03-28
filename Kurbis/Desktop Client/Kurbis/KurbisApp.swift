//
//  KurbisApp.swift
//  Kurbis
//
//  Created by Baptiste Bohelay on 19/11/2023.
//

import SwiftUI

@main
struct KurbisApp: App {
    
    // 1
    @State var testValue: Bool = false
    @ObservedObject var bluetoothConnector = BluetoothConnector.shared
    
    init() {
    }

    func checkForNewValueFromBluetooth() {
        if(bluetoothConnector.isConnected) {
            let newValue = bluetoothConnector.getNewValue();
            //        print(newValue)
            if(newValue.contains("next")) {
                let scriptSource = """
        tell application "Music"
            next track
        end tell
        """
                
                if let script = NSAppleScript(source: scriptSource) {
                    var errorDict: NSDictionary? = nil
                    script.executeAndReturnError(&errorDict)
                    if let error = errorDict {
                        print("AppleScript Error: \(error)")
                    }
                }
            }
            else if newValue.first == "v" {
                // Convert the SubSequence to String, then attempt to convert to Double
                if let volumeValue = Double(newValue.dropFirst()) {
                    let volume = volumeValue / 300.0 // volume is already a Double, direct calculation
                    CalibrationManager.shared.updateMicrophoneSignalLevel(newLevel: volume)
                }
            }
        }
    }
    
    func tryToConnectAgain() {
        bluetoothConnector.checkConnection()
        if(!bluetoothConnector.isConnected) {
            bluetoothConnector.tryToReconnect();
        }
        testValue = bluetoothConnector.isConnected
    }

    
    var body: some Scene {
        let timerConnect = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
        let timerValues = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
        
        WindowGroup {
            ContentView().task {
                tryToConnectAgain()
            }
            .onReceive(timerConnect) { _ in
                tryToConnectAgain()
            }
            .onReceive(timerValues) { _ in
                checkForNewValueFromBluetooth()
            }
        }
        // 2
        MenuBarExtra() {
            // 3
            Button("Preferences") {
                self.testValue = true
            }
            Divider()
            Button("Quit") {
              NSApplication.shared.terminate(nil)
            }
        } label: {
            // Custom label for the menu bar icon
            Image(nsImage: MenuBarIcon.createIcon(isConnected:bluetoothConnector.isConnected))

        }
    }
    
    

}



