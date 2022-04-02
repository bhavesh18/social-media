//
//  BaseViewController.swift
//  InstagramClone
//
//  Created by Dharam Singh on 10/02/20.
//  Copyright © 2020 Dharam Singh. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKLoginKit
import FacebookLogin
import Firebase
import FirebaseDatabase
import Toaster
import AudioToolbox

class BaseViewController: UIViewController {
    
    var ref: DatabaseReference!
    var databaseHandle = DatabaseHandle()
    let fbLoginManager =  LoginManager()
    var firebaseHelper = FireBaseHelper()
    var localData = CurrentSession.getI().localData
    let userdefault = UserDefaults.standard
    let date = Date()
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CurrentSession.getI().localData.snapshot < 0{
            return
        }
        
    }
    
    func loginAlert(title: String = "Error", msg: String = "Invalid Credentials"){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: - Toast message
    func showToastMessage(message: String) {
        if let currentToast = ToastCenter.default.currentToast {
            currentToast.cancel()
        }
        Toast(text: message).show()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) //vibrate on toast
    }
    
}


extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
}





