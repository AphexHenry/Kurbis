//
//  KurbisApp.swift
//  Kurbis
//
//  Created by Baptiste Bohelay on 19/11/2023.
//

import SwiftUI

@main
final class KurbisApp: App {
    // 1
    @State var currentNumber: String = "1"
    var timer: Timer?
    let myBlueTooh:BluetoothConnector
    
    required init() {
        // AnotherFile.swift
        myBlueTooh = BluetoothConnector(property: "Example")
        startRepeatingFunction()
    
//        let scriptSource = """
//        tell application "Music"
//            playpause
//        end tell
//        """
//
//        if let script = NSAppleScript(source: scriptSource) {
//            var errorDict: NSDictionary? = nil
//            script.executeAndReturnError(&errorDict)
//            if let error = errorDict {
//                print("AppleScript Error: \(error)")
//            }
//        }
        
//        let process = Process()
//        let pipe = Pipe()
//
//        // Set the path to the osascript command line tool
//        process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
//        let appleScriptCommand = "tell application \"Music\" to pause"
//
//
//        // Pass the command as an argument to osascript
//        process.arguments = ["-e", appleScriptCommand]
//
//        process.standardOutput = pipe
//        process.standardError = pipe
//
//        do {
//            try process.run() // Run the command
//            process.waitUntilExit() // Wait for the command to finish
//
//            let data = pipe.fileHandleForReading.readDataToEndOfFile()
//            if let output = String(data: data, encoding: .utf8) {
//                print(output) // Print the command output
//            }
//        } catch {
//            print("An error occurred: \(error)")
//        }
    }
    
    func startRepeatingFunction() {
        // Schedule a timer to call `repeatedFunction` every 2 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(repeatedFunction), userInfo: nil, repeats: true)
    }

    @objc func repeatedFunction() {
        print("Function is called repeatedly")
        let newValue = myBlueTooh.getNewValue();
        print(newValue)
        // Your repeated code here
    }
    
    func stopRepeatingFunction() {
        timer?.invalidate()
        timer = nil
    }

    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // 2
        MenuBarExtra(self.currentNumber, systemImage: "\(self.currentNumber).circle") {
            // 3
            Button("One") {
                self.currentNumber = "1"
            }
            Button("Two") {
                self.currentNumber = "2"
            }
            Button("Three") {
                self.currentNumber = "3"
            }
            Divider()
            Button("Quit") {
              NSApplication.shared.terminate(nil)
            }
        }
    }

}
