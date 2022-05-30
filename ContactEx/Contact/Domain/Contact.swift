//
// Contact.swift
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

/// A user define by his first and last name, also contain an email adress
struct Contact: Identifiable, Codable {
        
    // MARK: Variables
    
    var id: Int
    
    var firstName: String
    var lastName: String
    var emailAdress: String?
    
    // MARK: Init
    
    init(firstName: String, lastName: String, emailAdress: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.emailAdress = emailAdress
        
        var hasher = Hasher()
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(emailAdress)
        self.id = hasher.finalize()
    }
    
}
