//
// ContactListView.swift
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
import RxSwift
import SwiftUI

/// Display Fake and Phone contacts with picker selection
struct ContactView: View {
    
    //MARK: Properties
    
    /// View model for Contact View
    @StateObject var contactViewModel: ContactViewModel
    
    /// User's phone contacts
    @State private var phoneContacts: [Contact] = []
    
    /// Fake json contacts
    @State private var fakeContacts: [Contact] = []
            
    /// Picker selection between Phone and Fake contacts
    @State private var selection: ContactType = .fakeContact
    
    /// Display error if contacts access are refused
    @State private var showingAlert = false
    
    /// Dispose bag
    private let bag = DisposeBag()
    
    // MARK: Computed properties

    /// Which contact the user has selected
    private var selectedContacts: [Contact] {
        switch(selection) {
            case .fakeContact:
                return fakeContacts
            case .phoneContact:
                return phoneContacts
        }
    }
    
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
            if selection == .phoneContact && contactViewModel.isNotAuthorizedAccess {
                Spacer()
                Text("unauthorizedAccessContactView")
                Button("openSettingsContact", action: openSettings)
                Spacer()
            } else {
                ContactListView(contacts: selectedContacts)
            }
            
            Spacer()
            
            Picker("contactType", selection: $selection) {
                ForEach(ContactType.allCases, id: \.self) { value in
                    Text(value.localizedName)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    SortMenuView(phoneContacts: $phoneContacts, fakeContacts: $fakeContacts)
                }
            }
        }
        .navigationTitle("yourContacts")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            contactViewModel.fakeContacts.bind(onNext: { updatedContacts in
                fakeContacts = updatedContacts
            }).disposed(by: bag)
            
            contactViewModel.phoneContacts.bind(onNext: { updatedContacts in
                phoneContacts = updatedContacts
            }).disposed(by: bag)
            
            contactViewModel.fetchPhoneContacts()
            
            if contactViewModel.isNotAuthorizedAccess {
                showingAlert = true
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("contactRefused"))
        }
    }
}


/// List all the contacts
struct ContactListView: View {
    
    // MARK: Variables
    
    let contacts: [Contact]
    
    // MARK: View
    
    var body: some View {
        List(contacts) { contact in
            ContactItemView(contact: contact)
        }
    }
}

/// Display first name, last name and email Adress of the contact
struct ContactItemView: View {
    
    // MARK: Variables
    
    let contact: Contact
    
    // MARK: View
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(contact.firstName)
                        .font(.title2)
                    Text(contact.lastName)
                        .font(.title2)
                }
                HStack {
                    Text(contact.emailAdress ?? "")
                        .font(.subheadline)
                }
            }
            .padding(.leading)
            Spacer()
        }
    }
}

/// View that sort by first or last name with a Menu button
struct SortMenuView: View {
    
    // MARK: Variables
    
    /// User's phone contacts
    @Binding var phoneContacts: [Contact]
    
    /// Fake json contacts
    @Binding var fakeContacts: [Contact]
    
    // MARK: Sorting functions
    
    /// Sort both phone and fake contacts  by family name
    private func sortContactByFamilyName() {
        phoneContacts.sort { $0.lastName < $1.lastName }
        fakeContacts.sort { $0.lastName < $1.lastName }
    }
    
    /// Sort both phone and fake contacts  by first name
    private func sortContactByFirstName() {
        phoneContacts.sort { $0.firstName < $1.firstName }
        fakeContacts.sort { $0.firstName < $1.firstName }
    }
    
    // MARK: View
    
    var body: some View {
        Menu("sortContacts") {
            Button("sortByFirstName", action: sortContactByFirstName)
            Button("sortByLastName", action: sortContactByFamilyName)
        }
    }
}

// MARK: Preview

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(contactViewModel: ContactViewModel())
    }
}
