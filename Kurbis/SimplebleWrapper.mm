//
//  SimplebleWrapper.cpp
//  Kurbis
//
//  Created by Baptiste Bohelay on 19/11/2023.
//

#import "SimplebleWrapper.h"

#include <iomanip>
#include <iostream>
#include <sstream>

#include "common/utils.h"

#include "simpleble/Adapter.h"

#import "iTunes.h"

SimpleBLE::Peripheral sPeripheral;
std::pair<SimpleBLE::BluetoothUUID, SimpleBLE::BluetoothUUID> sUuids;

@implementation SimplebleClassWrapper {

}

- (instancetype)init {
    self = [super init];
    
//    NSString *scriptSource = @"tell application \"Music\" to pause";
//    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptSource];
//    NSDictionary *errorDict = nil;
//    [script executeAndReturnError:&errorDict];
//    if (errorDict) {
//        NSLog(@"AppleScript Error: %@", errorDict);
//    }
//    return self;
    
    if (self) {
        sPeripheral = getOurDriver();
        sPeripheral.connect();
        
        // Store all service and characteristic uuids in a vector.
        
        for (auto service : sPeripheral.services()) {
            for (auto characteristic : service.characteristics()) {
                sUuids = std::make_pair(service.uuid(), characteristic.uuid());
            }
        }
    }
    return self;
}

-(NSString *) getNewValue {
    SimpleBLE::ByteArray rx_data = sPeripheral.read(sUuids.first, sUuids.second);
//    std::cout << "Characteristic content is: ";
//    Utils::print_byte_array(rx_data);
    std::string str(rx_data.begin(), rx_data.end());
    NSString *returnString = @(str.c_str());
    if(lastValue != returnString) {
        lastValue = returnString;
        return returnString;
    }
    else {
        return @"";
    }
}

SimpleBLE::Peripheral getOurDriver() {
    auto adapter_optional = Utils::getAdapter();

    if (!adapter_optional.has_value()) {
        assert(false);
        return SimpleBLE::Peripheral();
    }

    auto adapter = adapter_optional.value();

    adapter.set_callback_on_scan_found([](SimpleBLE::Peripheral peripheral) {
        std::cout << "Found device: " << peripheral.identifier() << " [" << peripheral.address() << "] "
                  << peripheral.rssi() << " dBm" << std::endl;
    });

    adapter.set_callback_on_scan_updated([](SimpleBLE::Peripheral peripheral) {
        std::cout << "Updated device: " << peripheral.identifier() << " [" << peripheral.address() << "] "
                  << peripheral.rssi() << " dBm" << std::endl;
    });

    adapter.set_callback_on_scan_start([]() { std::cout << "Scan started." << std::endl; });

    adapter.set_callback_on_scan_stop([]() { std::cout << "Scan stopped." << std::endl; });

    // Scan for 5 seconds.
    adapter.scan_for(5000);

    std::cout << "Scan complete." << std::endl;

    std::vector<SimpleBLE::Peripheral> peripherals = adapter.scan_get_results();
    std::cout << "The following devices were found:" << std::endl;
    for (size_t i = 0; i < peripherals.size(); i++) {
        std::string connectable_string = peripherals[i].is_connectable() ? "Connectable" : "Non-Connectable";
        std::string peripheral_string = peripherals[i].identifier() + " [" + peripherals[i].address() + "] " +
                                        std::to_string(peripherals[i].rssi()) + " dBm";

        std::cout << "[" << i << "] " << peripheral_string << " " << connectable_string << std::endl;

        std::cout << "    Tx Power: " << std::dec << peripherals[i].tx_power() << " dBm" << std::endl;
        std::cout << "    Address Type: " << peripherals[i].address_type() << std::endl;

        std::vector<SimpleBLE::Service> services = peripherals[i].services();
        for (auto& service : services) {
            std::cout << "    Service UUID: " << service.uuid() << std::endl;
            std::cout << "    Service data: ";
            Utils::print_byte_array(service.data());
            if(service.uuid() == "4fafc201-1fb5-459e-8fcc-c5c9c331914b") {
                std::cout << "Device Found!";
                return peripherals[i];
            }
        }

        std::map<uint16_t, SimpleBLE::ByteArray> manufacturer_data = peripherals[i].manufacturer_data();
        for (auto& [manufacturer_id, data] : manufacturer_data) {
            std::cout << "    Manufacturer ID: " << manufacturer_id << std::endl;
            std::cout << "    Manufacturer data: ";
            Utils::print_byte_array(data);
        }
    }
    return SimpleBLE::Peripheral();
}

- (void)dealloc {
    
}

@end
