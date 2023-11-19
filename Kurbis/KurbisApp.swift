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
    @State var currentNumber: String = "1"
    
    init() {
        // AnotherFile.swift
        let myBlueTooh = BluetoothConnector(property: "Example")
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // 2
        MenuBarExtra(currentNumber, systemImage: "\(currentNumber).circle") {
            // 3
            Button("One") {
                currentNumber = "1"
            }
            Button("Two") {
                currentNumber = "2"
            }
            Button("Three") {
                currentNumber = "3"
            }
            Divider()
            Button("Quit") {
              NSApplication.shared.terminate(nil)
            }
        }
    }

}
