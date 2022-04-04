//
//  TermsandConditionViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 30/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit
import MessageUI

class HelpViewController: BaseViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var subjectTxtField: UITextField!
    @IBOutlet weak var detailSubject: UITextView!
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        contactUs()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func contactUs() {

        let email = emailTxtField.text! // insert your email here
        let subject = subjectTxtField.text!
        let bodyText = detailSubject.text!

        // https://developer.apple.com/documentation/messageui/mfmailcomposeviewcontroller
        if MFMailComposeViewController.canSendMail() {

            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self 

            mailComposerVC.setToRecipients([email])
            mailComposerVC.setSubject(subject)
            mailComposerVC.setMessageBody(bodyText, isHTML: false)

            self.present(mailComposerVC, animated: true, completion: nil)

        } else {
            print("Device not configured to send emails, trying with share ...")

            let coded = "mailto:\(email)?subject=\(subject)&body=\(bodyText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let emailURL = URL(string: coded!) {
                if #available(iOS 10.0, *) {
                    if UIApplication.shared.canOpenURL(emailURL) {
                        UIApplication.shared.open(emailURL, options: [:], completionHandler: { (result) in
                            if !result {
                                print("Unable to send email.")
                            }
                        })
                    }
                }
                else {
                    UIApplication.shared.openURL(emailURL as URL)
                }
            }
        }
    }
}
