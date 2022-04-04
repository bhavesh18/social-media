//
//  ForgotPasswordViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 18/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase
import ObjectMapper
import Alamofire

class ForgotPasswordViewController: BaseViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
extension ForgotPasswordViewController{
    
    /* Button Actions */
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPasswordBtnTapped(_ sender: Any) {
        
        Auth.auth().sendPasswordReset(withEmail: emailTxtField.text!, completion: { (error) in
            if error != nil{
                
                let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetFailedAlert, animated: true, completion: nil)
                
            }else {
                
                let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetEmailSentAlert, animated: true, completion: nil)
            }
        })
        
    }
}
