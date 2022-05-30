//
// AroundDeviceView.swift
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

import SwiftUI
import RxSwift

/// View that scan and display around bluetooth peripherals
struct AroundDeviceView: View {
    
    // MARK: Properties
    
    @StateObject var aroundDeviceViewModel: AroundDeviceViewModel
    
    /// True if currently scanning around peripherals
    @State var isScanning: Bool = false
    
    /// True if Bluetooth is activated on device
    @State var isBleSwitchedOn: Bool = false
    
    /// Contains scanned peripherals
    @State var peripherals: [Peripheral] = []
    
    /// Display error if bluetooth access is refused
    @State private var showingAlert = false
    
    private let bag = DisposeBag()
    
    // MARK: Event handlers
    
    /// Open application settings that allow to authorization
    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
        
    // MARK: View
    
    var body: some View {
        VStack {
            if isBleSwitchedOn {
                Text("bluetoothSwitchOn").foregroundColor(.green)
            } else {
                Text("bluetoothSwitchOff").foregroundColor(.red)
            }
                        
            Divider()
                        
            if (aroundDeviceViewModel.isNotAuthorizedAccess) {
                Spacer()
                Text("unauthorizedAccessBluetoothView")
                Button("openSettingsBluetooth", action: openSettings)
                Spacer()
            } else {
                List(peripherals) { peripheral in
                    HStack {
                        Text(peripheral.name).font(.title2)
                        Text("\(peripheral.rssi)").font(.title3)
                    }
                }
            }
            
            Divider()
            
            if isScanning {
                Button {
                    aroundDeviceViewModel.stopScanning()
                } label: {
                    Text("stopScanningBluetoothDevices")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ContactButtonExStyle())
                
            } else {
                Button {
                    aroundDeviceViewModel.startScanning()
                } label: {
                    Text("startScanningBluetoothDevices")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ContactButtonExStyle())
                .disabled(aroundDeviceViewModel.isNotAuthorizedAccess
                          || !isBleSwitchedOn)
            }
        }
        .onAppear {
            aroundDeviceViewModel.peripherals.bind(onNext: { newPeripherals in
                peripherals = newPeripherals
            }).disposed(by: bag)
            
            aroundDeviceViewModel.isScanning.bind(onNext: { newIsScanning in
                isScanning = newIsScanning
            }).disposed(by: bag)
            
            aroundDeviceViewModel.isBLESwitchedOn.bind(onNext: { newIsBLESwitchedOn in
                isBleSwitchedOn = newIsBLESwitchedOn
            }).disposed(by: bag)
            
            if aroundDeviceViewModel.isNotAuthorizedAccess {
                showingAlert = true
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("bluetoothRefused"))
        }
        .padding()
    }
}

struct AroundDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        AroundDeviceView(aroundDeviceViewModel: AroundDeviceViewModel())
    }
}
