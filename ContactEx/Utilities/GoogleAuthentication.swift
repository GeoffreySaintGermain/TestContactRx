//
// GoogleAuth.swift
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

import Foundation
import GoogleSignIn

/// Used to authenticate via google
public class GoogleAuthentication {
    
    // MARK: Variables
    
    /// Singleton
    public static let shared = GoogleAuthentication()
    
    /// Logged user
    var user: GIDGoogleUser?
    
    /// Contains configuration with clientID
    let signInConfig = GIDConfiguration(clientID: "122582778472-2ag0lnq26po1qebjg801j2dmeierim68.apps.googleusercontent.com")
    
    // MARK: Init
    
    private init() {}
}
