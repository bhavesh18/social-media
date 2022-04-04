//
//  SignupViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 10/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKLoginKit
import FacebookLogin
import Firebase
import FirebaseDatabase
import ObjectMapper
import ANLoader

class SignupViewController: BaseViewController {
    
    // Variables
    var userExist = false
    var isSignUp = false
    
    // TextField Outlets
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var fullnameTxtfield: UITextField!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension SignupViewController{
    
    // Button Actions
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        checkDataExist()
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // All Functions
    func fetchDataFromFirebaseDataBase(child: String,completion: @escaping (DataSnapshot?) -> Void){
        ref = Database.database().reference()
        databaseHandle = ref.child(child).observe(.value, with: { (snapshot) in
        })
        completion(nil)
    }
    
    func fetchDataFromFireBase(onSuccess: @escaping (Bool) -> ()){
        
        self.fetchDataFromFirebaseDataBase(child: "users") { (userdata) in
            if let userdata = userdata{
                if let userlist  = userdata.value as? [[String : Any]]{
                    let list = Mapper<UserProfileData>().mapArray(JSONArray: userlist)
                    self.localData.usersList.removeAll()
                    self.localData.usersList.append(contentsOf: list)
                    
                }
            }
        }
    }
    
    
    func isValidInput() -> Bool{
        var isValid = false
        if(usernameTxtField.text == "" || fullnameTxtfield.text == "" || emailTxtField.text == "" || passwordTxtField.text == ""){
            isValid = false
        }else if(emailTxtField.text != "" && !emailTxtField.text!.isValidEmail()){
            self.loginAlert(title: "Invalid Email", msg: "")
            isValid = false
        }else{
            isValid = true
        }
        return isValid
    }
    
    // This function will create new user after Checking the database
    
    func checkDataExist(){
        
        if(isValidInput()){
            
            FireBaseHelper.ref.child("users").queryOrderedByKey().observe(.value) { (snapshot) in
                
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                    print(snapshot.count)
                    for snap in snapshot{
                        if let userList = snap.value as? [String: Any]{
                            let mappedData = Mapper<UserWrapperData>().mapArray(JSONArray: [userList])
                            // Email Comparison
                            
                            self.localData.userWrapperData.append(contentsOf: mappedData)
                            if mappedData.contains(where: { $0.profile.email == self.emailTxtField.text }) {
                                self.userExist = true
                                break
                            }
                            
                            if mappedData.contains(where: { $0.profile.username == self.usernameTxtField.text }) {
                                self.userExist = true
                                break
                            }
                            print("kkk1")
                        }
                        print("kkk2")
                    }
                    print("kkk3")
                }
                print("Putting sign up here called again after creating user because of for loop")
                if self.isSignUp == false{
                    self.handleSignUp()
                }
            }
        }else{
            
        }
    }
    
    
    func handleSignUp(){
        
        let email1 = emailTxtField.text!
        let password = passwordTxtField.text!
        let userName = usernameTxtField.text!
        
        if self.userExist{
            
            self.loginAlert(title: "Error", msg: "Email or Username Already Existed")
            
            self.isSignUp = false
            self.userExist = false
            
        }else{
            // Create new User after checking in database ----- Email registration done
            self.isSignUp = true
            let forAutoId =  (self.ref.child("users")).childByAutoId()
            forAutoId.child("profile").setValue(["username": userName,"email":email1,"password":password,"fullname":self.fullnameTxtfield.text!])
            CurrentSession.getI().localData.fireUserId = forAutoId.key ?? ""
            CurrentSession.getI().saveData()
            self.loginAlert(title: "Done", msg: "Sign Up Successfully"){
                self.dismiss(animated: true)
            }
            
            return
            
        }
    }
    
}
