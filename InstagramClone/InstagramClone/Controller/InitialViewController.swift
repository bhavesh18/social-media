//
//  InitialViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 02/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit

class InitialViewController: BaseViewController {
    
    var token = CurrentSession.getI().localData
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        showController()
    }
    
    
    func showController() {
       // CurrentSession.getI().localData.isLogged = false
        if token.isLogged {
            let vc = self.storyboard?.instantiateViewController(identifier: "TabViewController") as! TabViewController
                 vc.modalPresentationStyle = .fullScreen
                 self.present(vc, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "home", sender: self)
        }else{
            let vc = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                 vc.modalPresentationStyle = .fullScreen
                 self.present(vc, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "login", sender: self)
        }
    }
}
