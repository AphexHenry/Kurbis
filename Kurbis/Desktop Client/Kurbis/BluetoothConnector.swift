//
//  BluetoothConnector.swift
//  Kurbis
//
//  Created by Baptiste Bohelay on 19/11/2023.
//

import Foundation

class BluetoothConnector: ObservableObject {
    // Static property for the singleton instance
    static let shared = BluetoothConnector(property: "Example")
    
    var property: String
    let objcObject:SimplebleClassWrapper
    
    @Published var isConnected: Bool = false

    // Initialization method
    init(property: String) {
        self.property = property
        // SomeSwiftFile.swift
        objcObject = SimplebleClassWrapper()
    }

    func checkConnection() {
        // Perform your connection check and update the published property
        // This will automatically update any views observing this object
        isConnected = objcObject.isConnected() // Replace with actual connection checking logic
    }
    
    /*
     * will return a new value received from the connected device if available.
     */
    func tryToReconnect() {
        objcObject.tryToReconnect();
        checkConnection();
    }
    
    /*
     * will return a new value received from the connected device if available.
     */
    func getNewValue() -> String {
        return objcObject.getNewValue();
    }
    
    // Function to send a string value to the SimplebleClassWrapper
    func sendMessage(_ value: String) {
        objcObject.sendMessage(value)
    }
}
