//
// ContactViewModel.swift
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

import Contacts
import Foundation
import RxSwift
import SwiftUI
import UIKit
import RxRelay


///   @enum ContactType
///
///   @discussion Represents the type of contacts*
///   @constant phoneContact    Contacts from phone.
///   @constant fakeContact    Contacts from json file.
///
enum ContactType: String, Equatable, CaseIterable {
    case phoneContact = "enumPhoneContact"
    case fakeContact  = "enumFakeContact"
    
    /// Allow to localized enum String if used in View
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

/// Contain logic for contact view
class ContactViewModel: ObservableObject {
    
    //MARK: Properties
    
    /// Contacts from user's phone
    var phoneContacts = BehaviorRelay<[Contact]>(value: [])
    
    /// Contacts from json file
    var fakeContacts = BehaviorRelay<[Contact]>(value: [])
    
    /// Get family name, given name and email adresses from user's phone for each contact
    private let keysToFetch: [CNKeyDescriptor] = [CNContactFamilyNameKey, CNContactGivenNameKey, CNContactEmailAddressesKey] as [CNKeyDescriptor]
    
    /// Store that fetches and saves contacts
    private let store = CNContactStore()
    
    // MARK: Computed properties
    
    /// Check if user has not given permission to access contacts
    ///
    /// - Returns : True if the user has not explicitly given access to contacts
    ///             False otherwise
    var isNotAuthorizedAccess: Bool {
        return (CNContactStore.authorizationStatus(for: .contacts) == .denied ||
            CNContactStore.authorizationStatus(for: .contacts) == .restricted)
    }
            
    // MARK: Init
    
    /// Create and fetch contacts from json file
    public init() {
        fetchFakeContacts()
    }
    
    // MARK: Fetch contacts
    
    /// Fetches contacts from user's phone if the user gave the authorization
    ///     or ask for authorization
    ///     or stop if we don't have the permission
    public func fetchPhoneContacts() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized:
                enumerateContacts()
            case .notDetermined:
                requestContactPermission()
            default:
                print("Not authorized access")
        }
    }
    
    /// Fetches contacts from json file "contacts" and store them
    public func fetchFakeContacts() {
        var fakeContactsJson: [Contact] = []
        
        if let jsonData = FileReader().readLocalFile(forName: "contacts") {
            do {
                fakeContactsJson = try JSONDecoder().decode([Contact].self, from: jsonData)
                
                fakeContacts.accept(fakeContactsJson)
            } catch {
                print("error while decoding Json", error)
            }
        }        
    }
    
    /// Get contacts from user's phone and store them
    private func enumerateContacts() {
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        request.sortOrder = .familyName
        var newContacts: [Contact] = []
        
        do {
            try store.enumerateContacts(with: request,
                                        usingBlock: { contact, pointer in
                newContacts.append(Contact(firstName: contact.givenName,
                                           lastName: contact.familyName,
                                           emailAdress: contact.emailAddresses.first?.value as String?))
            })
            
            phoneContacts.accept(newContacts)
        } catch let error {
            print("failed to enumerate contact", error)
        }
    }
    
    // MARK: Permissions
    
    /// Ask permission to access contacts from user's phone
    private func requestContactPermission() {
        CNContactStore().requestAccess(for: .contacts) { granted, _ in
            if granted {
                self.fetchPhoneContacts()
            }
        }
    }
}
