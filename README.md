ContactEx
=========

'ContactEx' is a showCase app designed to display contacts, bluetooth peripherals and sign in with Google



* Authenticate with Google 
* Access phone contacts
* Also access fake contacts with data from json file
* Scan around bluetooth peripherals

It works with 'GoogleSignIn', 'GoogleSignInSwiftSupport', 'RxSwift', 'RxCocoa' modules import with Cocoa Pod.

----

# Getting Started

```
git clone https://github.com/GeoffreySaintGermain/TestContactRx.git
cd TestContactRx
pod install
open ContactEx.xcworkspace
```
----

# Usage

## Menu View

When the app start, 4 buttons are displayed

<br />
<img src="assets/MenuView.png" width="35%" alt="Menu view" />
<br />

The Language button on top right corner allow user to change between french and english language

<br />
<img src="assets/SettingLanguage.PNG" width="35%" alt="Change language" />
<br />

If Google Sign In button is clicked, the authentication flow start 

First the app ask for authorization to connect

<br />
<img src="assets/GoogleSignInAsk.PNG" width="35%" alt="Google ask to connect" />
<br />

Then the user can sign in with his account

<br />
<img src="assets/SelectAccountGoogle.PNG" width="35%" alt="Select google account" />
<br />

If the user is successfully logged, the contact view appear

## Contact view

When the view appear, the app ask permissions to access contacts

<br />
<img src="assets/ContactsAsk.PNG" width="35%" alt="Ask for Contact permission" />
<br />

Then display fake contacts from json file

<br />
<img src="assets/FakeContacts.PNG" width="35%" alt="Fake contact view" />
<br />

User can select with the picker which contact to display and display phone contacts if he gave the permission

<br />
<img src="assets/PhoneContacts.png" width="35%" alt="User's phone contacts" />
<br />

User can also sort contacts by first or last name

<br />
<img src="assets/SortContacts.PNG" width="35%" alt="Menu button to sort contacts" />
<br />

## Bluetooth view

When the view appear, the app ask permissions to access the bluetooth

<br />
<img src="assets/BluetoothAsk.PNG" width="35%" alt="Ask for Bluetooth permission" />
<br />

When the button is tapped, the application start scanning and displaying around bluetooth devices

<br />
<img src="assets/BluetoothView.PNG" width="35%" alt="Bluetooth View" />
<br />







