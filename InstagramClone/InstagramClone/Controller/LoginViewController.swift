//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 08/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKLoginKit
import FacebookLogin
import Firebase
import FirebaseDatabase
import ObjectMapper
import Alamofire


class LoginViewController: BaseViewController {
    
    var profileData =  CurrentSession.getI().loginData.profile
    var arrData = [UserProfileData]()
    var isLoggedIn = false
    var key  = ""
    var email = "jsracer71@gmail.com"
    var socialLogin = false
    
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension LoginViewController{
    
    /*  All Functiona and Actions */
    
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        if isEmpty().empty{
            self.loginAlert(title: "Invalid Credentials", msg: "Enter Correct Email or Password")
        }else if((usernameTxtField.text != "") && (!usernameTxtField.text!.isValidEmail())){
            self.loginAlert(title: "Invalid Email", msg: "Enter Correct Email")
        }else{
            loginInitView()
        }
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func resetPasswordBtntapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func fbLoginBtnTapped(_ sender: Any) {
        AccessToken.current = nil
        fbLogin()
    }
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
    }
    
    //Mark: Empty validatons
    
    func isEmpty() -> (msg: String,empty: Bool) {
        
        if usernameTxtField.text == ""{
            return("Username is Empty",true)
        }
        if passTxtField.text == ""{
            return("Password is Empty",true)
        }
        return("",false)
        
    }
    
    //Mark: Firebase data functions
    
    func loginInitView(){
        print(passTxtField.text!)
        firebaseHelper.authenticateUser(email: usernameTxtField.text!, password: passTxtField.text!) { (success) in
            if(success){
                if self.localData.socialLogin{
                    
                }else{
                    self.localData.profileData.password = self.passTxtField.text!
                }
                
                self.isLoggedIn = true
                
                CurrentSession.getI().localData.isLogged = self.isLoggedIn
                self.showToastMessage(message: "ho gya")
                
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: false, completion: nil)
            }else{
                self.loginAlert(title: "Invalid", msg: "Invalid Credentials")
            }
            CurrentSession.getI().saveData()
        }
    }
    
    
    //MARK:- Facebook Login
    
    func fbLogin() {
        let loginManager = LoginManager()
        // loginManager.logOut()
        loginManager.logIn(permissions:[ .publicProfile, .email], viewController: self) { loginResult in
            
            switch loginResult {
                
            case .failed(let error):
                //HUD.hide()
                print(error)
                
            case .cancelled:
                //HUD.hide()
                print("User cancelled login process.")
                
            case .success( _, _, _):
                print("Logged in!")
                self.getFBUserData()
            }
        }
    }
    
    /*  Getting data from facebook  */
    func getFBUserData() {
        
        //which if my function to get facebook user details
        if((AccessToken.current) != nil){
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    let dict = result as! [String : AnyObject]
                    
                    let picutreDic = dict as NSDictionary
                    
                    let tmpURL1 = picutreDic.object(forKey: "picture") as! NSDictionary
                    let tmpURL2 = tmpURL1.object(forKey: "data") as! NSDictionary
                    let finalURL = tmpURL2.object(forKey: "url") as! String
                    self.profileData.password  = finalURL
                    self.userdefault.set(finalURL, forKey: "picurl")
                    self.localData.profileData.profilepic = finalURL
                    
                    let idOfUser = picutreDic.object(forKey: "id") as! String
                    print(idOfUser)
                    //To get name
                     var tmpname = ""
                    if let nameOfUser = picutreDic.object(forKey: "name"){
                         tmpname = nameOfUser as! String
                        self.profileData.user_full_name = tmpname
                       self.localData.profileData.fullname = tmpname
                    }
                    
                    //To get name

                     var tmpusername = ""
                    if let nameOfUser = picutreDic.object(forKey: "username"){
                         tmpusername = nameOfUser as! String
                        self.profileData.userName = tmpusername
                       self.localData.profileData.username = tmpusername
                    }
                 
                    
                    //To get Email
                    var tmpEmailAdd = ""
                    if let emailAddress = picutreDic.object(forKey: "email") {
                        tmpEmailAdd = emailAddress as! String
                        self.profileData.user_email = tmpEmailAdd
                        self.localData.profileData.email = tmpEmailAdd
                        
                    }
//                    else {
//                        var usrName = nameOfUser
//                        usrName = usrName.replacingOccurrences(of: " ", with: "")
//                        tmpEmailAdd = usrName+"@facebook.com"
//                    }
                    
                    if let tmp = picutreDic.object(forKey: "picture") as? NSDictionary{
                        if let profile  = tmp["data"] as? NSDictionary{
                            print("------ \(profile)  -----")
                        }
                    }
                    self.facebookLoginDataView()
                    if self.key == ""{
                        return
                    }
                }
                print(error?.localizedDescription as Any)
            })
        }
    }
    
    /* ------ Check the data is correct to login ------- */
    
    func facebookLoginDataView(){
        
        
        if(localData.isFirstFbLogin){
            createFbUserInDatabase()
        }else{
            
            FireBaseHelper.ref.child("users").queryOrderedByKey().observe(.value) { (snapshot) in
                
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                    print(snapshot.count)
                    for snap in snapshot{
                        
                        if let userList = snap.value as? [String: Any]{
                            let mappedData = Mapper<UserWrapperData>().mapArray(JSONArray: [userList])
                            
                         
                            
                            if let first = mappedData.first{
                                
                                dump(first.profile)
                                print(first.profile.email)
                                print(self.email)
                                
                                
                                
                                if(first.profile.email == self.email ){
                                    
                                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
                                    viewController.modalPresentationStyle = .fullScreen
                                    self.localData.socialLogin = true
                                    self.localData.fireUserId = snap.key
                                    self.localData.userName = first.profile.username
                                    self.localData.profileData.userPhoneNumber = first.profile.userPhoneNumber
                                    self.localData.profileData.userGender = first.profile.userGender
                                    self.localData.profileData.userBio = first.profile.userBio
                                    self.localData.profileData.fullname = first.profile.fullname
                                    self.localData.profileData.profilepic = first.profile.profilepic
                                    self.localData.profileData.email = first.profile.email
                                    self.localData.profileData.username = first.profile.username
                                    self.localData.profileData.fbforfirsttime = false
                                    self.localData.snapshot = Int(snap.children.allObjects.count)
                                    CurrentSession.getI().saveData()
                                    self.present(viewController, animated: false, completion: nil)
                                }else{
                                    print("first.profile.email == self.email")
                                }
                            }else{
                                print("mapped.first")
                            }
                        }else{
                            print("userlist")
                        }
                    }
                }
            }
        }
    }
    
    /* -----------  Fb auth function  --------------  */
    
    func createFbUserInDatabase(){
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)

        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
//                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alertController.addAction(okayAction)
//                self.present(alertController, animated: true, completion: nil)
                
                return
            }else{
            
            self.localData.socialLogin = true
            
            let forAutoId =  (self.ref.child("users")).childByAutoId()
            forAutoId.child("profile").setValue(["fullname": user?.user.displayName,"email":user?.user.email,"profilepic":user?.user.photoURL?.description])
            
            self.localData.fireUserId = forAutoId.key ?? ""
            
            self.key = forAutoId.key ?? ""
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            viewController.modalPresentationStyle = .fullScreen
            CurrentSession.getI().localData.isLogged = self.isLoggedIn
            
            CurrentSession.getI().saveData()
            self.localData.isLogged = true
            self.localData.isFirstFbLogin = false
            self.localData.profileData.fbforfirsttime = true
            self.present(viewController, animated: false, completion: nil)
                
            }
        })
    }
}
