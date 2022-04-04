////
////  LoginViewController.swift
////  InstagramClone
////
////  Created by Jaspinder Singh on 08/03/22.
////  Copyright © 2020 Jaspinder Singh. All rights reserved.
////
//
//import UIKit
//import FacebookCore
//import FBSDKLoginKit
//import FacebookLogin
//import Firebase
//import FirebaseDatabase
//import ObjectMapper
//import Alamofire
//
//
//class LoginViewController: BaseViewController {
//    
//    
//    var profileData =  CurrentSession.getI().loginData.profile
//    var arrData = [UserProfileData]()
//    var isLoggedIn = false
//    var key  = ""
//    
//    @IBOutlet weak var usernameTxtField: UITextField!
//    @IBOutlet weak var passTxtField: UITextField!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
//    
//    func isEmpty() -> (msg: String,empty: Bool) {
//        
//        if usernameTxtField.text == ""{
//            return("Username is Empty",true)
//        }
//        if passTxtField.text == ""{
//            return("Password is Empty",true)
//        }
//        return("",false)
//        
//    }
//    
//    @IBAction func signUpBtnTapped(_ sender: Any) {
//        
//        if isEmpty().empty {
//            
//        }else{
//            
//        }
//        let vc = self.storyboard?.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
//        
//    }
//    @IBAction func resetPasswordBtntapped(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(identifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
//    }
//    
//    @IBAction func fbLoginBtnTapped(_ sender: Any) {
//        let fbLoginManager = LoginManager()
//        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
//            if let error = error {
//                print("Failed to login: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let accessToken = AccessToken.current else {
//                print("Failed to get access token")
//                return
//            }
//            
//            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//            
//            // Perform login by calling Firebase APIs
//            Auth.auth().signIn(with: credential, completion: { (user, error) in
//                if let error = error {
//                    print("Login error: \(error.localizedDescription)")
//                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(okayAction)
//                    self.present(alertController, animated: true, completion: nil)
//                    
//                    return
//                }
//                
//                // Present the main view
//
//             let forAutoId =  (self.ref.child("users")).childByAutoId()
//             forAutoId.child("profile").setValue(["username": user?.user.displayName,"email":user?.user.email,"profilepic":user?.user.photoURL?.description])
//             
//             CurrentSession.getI().localData.fireUserId = forAutoId.key ?? ""
//             self.key = forAutoId.key ?? ""
//             let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
//             viewController.modalPresentationStyle = .fullScreen
//             CurrentSession.getI().localData.isLogged = self.isLoggedIn
//             self.present(viewController, animated: false, completion: nil)
//             CurrentSession.getI().saveData()
//             CurrentSession.getI().localData.isLogged = true
//             CurrentSession.getI().localData.isFirstFbLogin = false
//             CurrentSession.getI().saveData()
//                
//            })
//            
//        }
//    }
//    
//    @IBAction func loginBtnTapped(_ sender: Any) {
//        
//        firebaseHelper.authenticateUser(email: usernameTxtField.text!, password: passTxtField.text!) { (success) in
//            if(success){
//                
//                self.isLoggedIn = true
//                
//                CurrentSession.getI().localData.isLogged = self.isLoggedIn
//                self.showToastMessage(message: "ho gya")
//                
//                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
//                viewController.modalPresentationStyle = .fullScreen
//                self.present(viewController, animated: false, completion: nil)
//            }else{
//                CurrentSession.getI().localData.fireUserId = ""
//                
//                self.loginAlert(title: "woo",msg: "nikal  phli fursat me")
//            }
//            CurrentSession.getI().saveData()
//        }
//    }
//    
//    
//    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//        
//        // ...
//    }
//    
//    
//    //MARK:- Facebook Login
//    
//    func fbLogin() {
//        let loginManager = LoginManager()
//        // loginManager.logOut()
//        loginManager.logIn(permissions:[ .publicProfile, .email], viewController: self) { loginResult in
//            
//            switch loginResult {
//                
//            case .failed(let error):
//                //HUD.hide()
//                print(error)
//                
//            case .cancelled:
//                //HUD.hide()
//                print("User cancelled login process.")
//                
//            case .success( _, _, _):
//                print("Logged in!")
//                self.getFBUserData()
//            }
//        }
//        
//        
//    }
//    
//    
//    func cred(){
//        
//        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
//        
//        if(localData.isFirstFbLogin){
//            Auth.auth().signIn(with: credential, completion: { (user, error) in
//                if let error = error {
//                    print("Login error: \(error.localizedDescription)")
//                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(okayAction)
//                    self.present(alertController, animated: true, completion: nil)
//
//                    return
//                }
//                
//                
//                
//                let forAutoId =  (self.ref.child("users")).childByAutoId()
//                forAutoId.child("profile").setValue(["username": user?.user.displayName,"email":user?.user.email,"photo":user?.user.photoURL?.description])
//                
//                CurrentSession.getI().localData.fireUserId = forAutoId.key ?? ""
//                self.key = forAutoId.key ?? ""
//                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
//                viewController.modalPresentationStyle = .fullScreen
//                CurrentSession.getI().localData.isLogged = self.isLoggedIn
//                self.present(viewController, animated: false, completion: nil)
//                CurrentSession.getI().saveData()
//                CurrentSession.getI().localData.isLogged = true
//                CurrentSession.getI().localData.isFirstFbLogin = false
//                CurrentSession.getI().saveData()
//            })
//        }else{
//            if let user = Auth.auth().currentUser{
//                user.link(with: credential) { (data, err) in
//                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
//                                 viewController.modalPresentationStyle = .fullScreen
//                                 CurrentSession.getI().localData.isLogged = self.isLoggedIn
//                                 self.present(viewController, animated: false, completion: nil)
//                    dump(data)
//                }
//            }
//            
//        }
//        
//        
//    }
//    
//    func retFIrebaseData(){
//        let ref = Database.database().reference(withPath: "users")
//        ref.observeSingleEvent(of: .value, with: { snapshot in
//            print(snapshot.value!)
//            
//            if !snapshot.exists() { return }
//            
//            print(snapshot) // Its print all values including Snap (User)
//            
//            print(snapshot.key)
//            
//            let username = snapshot.childSnapshot(forPath: "username").value
//            print(username!)
//            let username1 = snapshot.childSnapshot(forPath: "email").value
//            print(username1!)
//            
//        })
//        
//    }
//    
//    func getFBUserData() {
//        
//        //which if my function to get facebook user details
//        if((AccessToken.current) != nil){
//            
//            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
//                if (error == nil){
//                    
//                    let dict = result as! [String : AnyObject]
//                    
//                    let picutreDic = dict as NSDictionary
//                    
//                    let tmpURL1 = picutreDic.object(forKey: "picture") as! NSDictionary
//                    let tmpURL2 = tmpURL1.object(forKey: "data") as! NSDictionary
//                    let finalURL = tmpURL2.object(forKey: "url") as! String
//                    self.profileData.password  = finalURL
//                    self.userdefault.set(finalURL, forKey: "picurl")
//                    
//                    
//                    //To get name
//                    let nameOfUser = picutreDic.object(forKey: "name") as! String
//                    self.profileData.user_full_name = nameOfUser
//                    
//                    //To get Email
//                    var tmpEmailAdd = ""
//                    if let emailAddress = picutreDic.object(forKey: "email") {
//                        tmpEmailAdd = emailAddress as! String
//                        self.profileData.user_email = tmpEmailAdd
//                    }
//                    else {
//                        var usrName = nameOfUser
//                        usrName = usrName.replacingOccurrences(of: " ", with: "")
//                        tmpEmailAdd = usrName+"@facebook.com"
//                    }
//                    
//                    if let tmp = picutreDic.object(forKey: "picture") as? NSDictionary{
//                        if let profile  = tmp["data"] as? NSDictionary{
//                            print("-----------")
//                            
//                            
//                        }
//                    }
//                    
//                    
//                    
//                    self.cred()
//                    if self.key == ""{
//                        return
//                    }
//                    
//                }
//                
//                print(error?.localizedDescription as Any)
//            })
//        }
//    }
//    
//}
