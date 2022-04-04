//
//  CurrentSession.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 11/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class FirebaseRepo: BaseViewController {
    
    var userData = CurrentSession.getI().localData
    
    func gellAllFireBAseData(){
        
        self.ref.child("users").child("profile").queryOrderedByKey().observe(.value) { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let user = snap.value as? [String: Any]{
                        
                        
                        let email  = user["email"] as? String
                        
                        
                        let pass = user["password"] as? String
                        
                        
                        let username = user["username"] as? String
                        
                        self.userData.userPostData.append(UserPostData(email: email!, password: pass!, username: username!))
                        CurrentSession.getI().localData.userPostData = self.userData.userPostData
                        CurrentSession.getI().saveData()
                        
                       
                       
                    }
                    
                }
                
            }
        }
    }
    override func viewDidLoad() {
           super.viewDidLoad()
           
           
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gellAllFireBAseData()
    }
}
