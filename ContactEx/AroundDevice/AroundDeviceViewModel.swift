//
// AroundDeviceViewModel.swift
//
// Copyright 2022 Geoffrey Saint-Germain
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import CoreBluetooth
import Foundation
import RxCocoa
import RxSwift

/// Contain logic for aroundDevice view
class AroundDeviceViewModel: NSObject, ObservableObject, CBCentralManagerDelegate {
    
    // MARK: Properties
    
    /// Bluetooth manager
    private var bleCentralManager: CBCentralManager?
    
    /// List of peripherals around
    var peripherals = BehaviorRelay<[Peripheral]>(value: [])
    
    /// Is the application currently scanning near peripherals
    var isScanning = BehaviorRelay<Bool>(value: false)
    
    /// Is bluetooth currently switched on
    var isBLESwitchedOn = BehaviorRelay<Bool>(value: false)
    
    // MARK: Computed properties
    
    /// Check if user has not given permission to access bluetooth
    ///
    /// - Returns : True if the user has not explicitly given bluetooth access
    ///             False otherwise
    var isNotAuthorizedAccess: Bool {
        return (CBCentralManager.authorization == .denied ||
                CBCentralManager.authorization == .restricted)
    }
          
    // MARK: Init
    
    /// Initialize a new around device viewmodel with manager
    override init() {
        super.init()
        
        bleCentralManager = CBCentralManager(delegate: self, queue: nil)
        bleCentralManager?.delegate = self
    }
    
    // MARK: Manager functions
    
    /// Called when bluetooth is switched on/off
    ///
    /// - Parameters:
    ///     - central: Manager
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isBLESwitchedOn.accept(true)
        }
        else {
            isBLESwitchedOn.accept(false)
        }
    }
    
    /// Add new discovered peripherals to peripherals list
    ///
    /// - Parameters:
    ///     - central: Manager
    ///     - didDiscover: Peripheral just discovered (potentially more than once)
    ///     - advertisementData: Dictionnary of advertisement data
    ///     - rssi: Signal power
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.value.contains(where: { $0.id == peripheral.identifier }) {
            let newPeripheral = Peripheral(id: peripheral.identifier, name: peripheral.name ?? "Unknown", rssi: RSSI.intValue)
            peripherals.accept(peripherals.value + [newPeripheral])
        }
    }
    
    // MARK: Scanning functions
    
    /// Start scanning around peripherals
    func startScanning() {
        bleCentralManager?.scanForPeripherals(withServices: nil, options: nil)
        isScanning.accept(true)
    }
    
    /// Stop scanning around peripherals
    func stopScanning() {
        bleCentralManager?.stopScan()
        isScanning.accept(false)
    }
    
}
