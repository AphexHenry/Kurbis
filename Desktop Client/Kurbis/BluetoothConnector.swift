//
//  BluetoothConnector.swift
//  Kurbis
//
//  Created by Baptiste Bohelay on 19/11/2023.
//

import Foundation

class BluetoothConnector {
    var property: String
    let objcObject:SimplebleClassWrapper

    // Initialization method
    init(property: String) {
        self.property = property
        // SomeSwiftFile.swift
        objcObject = SimplebleClassWrapper()
    }
    
    /*
     * will return a new value received from the connected device if available.
     */
    func getNewValue() -> String {
        return objcObject.getNewValue();
    }
}
