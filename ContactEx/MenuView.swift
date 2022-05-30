//
// MenuView.swift
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

import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

/// Menu with 3 buttons :
///     - Google sign in button and access to contacts if authentication is completed
///     - Access to contacts
///     - Access to bluetooth
struct MenuView: View {
    
    // MARK: Variables
    
    /// Authentication singleton for google services
    @State private var authenticationService = GoogleAuthentication.shared
    
    /// Show contact view when sign in is completed
    @State private var isShowingContactView = false
    
    // MARK: Event handlers
    
    /// Handle and show sign in view with google
    func handleSignInButton() {        
        if let rootViewController = UIApplication.shared.currentUIWindow()?.rootViewController {
            GIDSignIn.sharedInstance.signIn(with: authenticationService.signInConfig, presenting: rootViewController) { user, error in
                guard user != nil,
                      error == nil else {
                    print("error sign in")
                    return
                }
                
                authenticationService.user = user
                isShowingContactView = true
            }
        }
    }
    
    /// Open application settings that allow to change language
    private func switchLanguage() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: View
    
    var body: some View {
        NavigationView {
            VStack {
                
                NavigationLink(destination: ContactView(contactViewModel: ContactViewModel()), isActive: $isShowingContactView) { EmptyView() }
                Button {
                    handleSignInButton()
                } label: {
                    Text("googleButtonSignIn")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ContactButtonExStyle())
                        
                Divider()
                
                NavigationLink(destination: ContactView(contactViewModel: ContactViewModel())) {
                    Text("contactButtonNavigation")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ContactButtonExStyle())
                NavigationLink(destination: AroundDeviceView(aroundDeviceViewModel: AroundDeviceViewModel())) {
                    Text("bluetoothButtonNavigation")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ContactButtonExStyle())
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("buttonChooseLanguage", action: switchLanguage)
                    }
                }
            }
        }        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
