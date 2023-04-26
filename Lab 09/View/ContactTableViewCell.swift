//
//  ContactTableViewCell.swift
//  Lab 09
//
//  Created by Lê Duy Tân on 13/04/2023.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var contactPhotoImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneNumberLabel: UILabel!
    
    // Set up contact values
    func setCallValuesOf(_ contact: Contact) {
        contactNameLabel.text = contact.firstName + " " + contact.lastName
        contactPhoneNumberLabel.text =  contact.phoneNumber
        
        let image = UIImage(data: contact.photo)
        contactPhotoImageView.image = image
        contactPhotoImageView.makeRounded()
    }
   
}
