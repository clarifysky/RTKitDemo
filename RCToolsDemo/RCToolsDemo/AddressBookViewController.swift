//
//  AddressBookViewController.swift
//  
//
//  Created by Rex Tsao on 3/22/16.
//
//

import UIKit
import AddressBook

class AddressBookViewController: UIViewController {

    private var addressBook: ABAddressBookRef?
    private var contacts: [Dictionary<String, String>]?
    
    private var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Contacts"
        
        var error: Unmanaged<CFErrorRef>? = nil
        self.addressBook = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        
        // Request authorization.
        let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()
        if sysAddressBookStatus == ABAuthorizationStatus.NotDetermined {
            RTPrint.shareInstance().prt("requesting...")
            ABAddressBookRequestAccessWithCompletion(self.addressBook, {
                success, error in
                if success {
                    // Load all people in addressBook.
                    self.loadContacts()
                } else {
                    RTPrint.shareInstance().prt(error)
                }
            })
        } else if sysAddressBookStatus == .Denied || sysAddressBookStatus == .Restricted {
            RTPrint.shareInstance().prt("access denied")
        } else if sysAddressBookStatus == .Authorized {
            self.loadContacts()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func attachTable() {
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
    }

    private func loadContacts() {
        
        let dataRead = ABAddressBookCopyArrayOfAllPeople(self.addressBook).takeRetainedValue() as NSArray
        RTPrint.shareInstance().prt("count of addressBook: \(dataRead.count)")
        self.extractUsers(dataRead)
        
        self.attachTable()
    }
    
    private func extractUsers(dataRead: NSArray) {
        var users = [Dictionary<String, String>]()
        for contact in dataRead {
            // Name of people.
            let firstName = ABRecordCopyValue(contact, kABPersonFirstNameProperty)?.takeRetainedValue() as! String? ?? ""
            // Family name.
            let lastName = ABRecordCopyValue(contact, kABPersonLastNameProperty)?.takeRetainedValue() as! String? ?? ""
            let name = lastName + " " + firstName
            
            // phone
            var phone = ""
            let phoneValues: ABMutableMultiValueRef? = ABRecordCopyValue(contact, kABPersonPhoneProperty).takeRetainedValue()
            if phoneValues != nil {
                let count = ABMultiValueGetCount(phoneValues)
                if count > 0 {
                    // I only take the first phone number here.
                    let tmp = ABMultiValueCopyLabelAtIndex(phoneValues, 0)
//                    var localizedPhoneLabel = ""
                    if tmp != nil {
//                        let phoneLabel = ABMultiValueCopyLabelAtIndex(phoneValues, 0).takeRetainedValue() as CFStringRef
                        // convert to localized labe.
//                        localizedPhoneLabel = ABAddressBookCopyLocalizedLabel(phoneLabel).takeRetainedValue() as String
                    }
                    
                    phone = ABMultiValueCopyValueAtIndex(phoneValues, 0).takeRetainedValue() as! String
//                    println(localizedPhoneLabel + phone)
                }
            }
            
            RTPrint.shareInstance().prt("name: " + name + ", phone: " + phone)
            users.append(["name": name, "phone": phone])
        }
        self.contacts = users
        self.tableView?.reloadData()
    }
}

extension AddressBookViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addressBook")! as UITableViewCell
//        if cell == nil {
//            cell = UITableViewCell(style: .Default, reuseIdentifier: "addressBook")
//        }
        cell.textLabel?.text = self.contacts![indexPath.row]["name"]! + " " + self.contacts![indexPath.row]["phone"]!
        return cell 
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts!.count
    }
}
