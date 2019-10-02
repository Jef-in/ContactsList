//
//  ViewController.swift
//  ContactProject
//
//  Created by Jefin on 02/10/19.
//  Copyright © 2019 jefin. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var Array = [ContactModels]()
   
    @IBOutlet var ContactsTable: UITableView!
    
    @IBOutlet var ContactsTableHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func fetchContacts(){
        
    let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            
            if let err = err {
                
                print(err)
            }
            
            if granted {
                
                print("granted access")
                
                let keys = [CNContactGivenNameKey,CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                   try store.enumerateContacts(with: request, usingBlock: { (contact, stopenumerate) in
                        
                        print(contact.givenName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                       self.Array.append(ContactModels(name: contact.givenName, Phonenumber: contact.phoneNumbers.first?.value.stringValue ?? "",Image:contact.thumbnailImageData!))
                    })
            
                } catch let err{
                    
                    print(err)
                }
                print(self.Array)
                DispatchQueue.main.async {
                    
                    self.ContactsTable.reloadData()
                    self.ContactsTableHeight.constant = self.ContactsTable.contentSize.height
                }
            } else {
                
                print("denied access")
            }
        }
    }
    
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
 return self.Array.count
    
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath) as! ContactsCell
    
cell.ContactImage.image = UIImage(data: self.Array[indexPath.row].Image)
cell.Name.text = self.Array[indexPath.row].name
cell.Phone.text = self.Array[indexPath.row].Phonenumber
    
return cell
}
    
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
return 85
    
}

}

