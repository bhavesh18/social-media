//
//  EditViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 28/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit
import FirebaseStorage

class EditViewController: BaseViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var image: UIImage?
    var imgo = ""
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var genderTxtField: UITextField!
    @IBOutlet weak var bioTxtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Edit Profile"
        
    }
}

extension EditViewController {
    
    func initView(){
        if localData.profileData.ifUsernameEmpty {
            
            userNameTxtField.isUserInteractionEnabled = true
        }else{
            userNameTxtField.isUserInteractionEnabled = false
        }
        
        print(self.localData.profileData.password)
        userNameTxtField.text = localData.profileData.username
        nameLbl.text = localData.profileData.fullname
        nameTxtField.text =  localData.profileData.fullname
        emailTxtField.text = localData.profileData.email
        phoneTxtField.text = localData.profileData.userPhoneNumber
        bioTxtView.text = localData.profileData.userBio
        genderTxtField.text = localData.profileData.userGender

        if self.localData.profileData.profilepic != ""{
            profileImage.downloadImage(from: self.localData.profileData.profilepic)
        }
    }
    
    
    
    // Action of all buttons
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfilePicBtnPressed(_ sender: Any) {
        pickPhoto()
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        let activityNode = self.ref.child("users").child(self.localData.fireUserId).child("profile")
        let key  = activityNode.key
        
        let uid = localData.fireUserId
        // let ref = Database.database().reference()
        let storage = Storage.storage().reference(forURL: "gs://capstone-22743.appspot.com")
        
        
        let imageRef = storage.child("profile").child(uid).child("\(String(describing: key)).jpg")
        
        let data = self.profileImage.image!.jpegData(compressionQuality: 0.6)
        
        let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = [
                        "userPhoneNumber" : self.phoneTxtField.text!,
                        "userGender" : self.genderTxtField.text!,
                        "profilepic":url.absoluteString,
                        "userBio" : self.bioTxtView.text!,
                        "password":self.localData.profileData.password,
                        "fullname" : self.localData.profileData.fullname,
                        "username": self.localData.profileData.username,
                        "email": self.localData.profileData.email
                        ] as [String : Any]
                    
                    activityNode.updateChildValues(feed)
                    self.imgo = url.absoluteString
                    self.localData.profileData.profilepic = self.imgo
                    CurrentSession.getI().saveData()
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        }
        
        uploadTask.resume()
        localData.profileData.userBio = bioTxtView.text!
        localData.profileData.userGender = genderTxtField.text!
        localData.profileData.userPhoneNumber = phoneTxtField.text!
        localData.profileData.profilepic = self.imgo
        localData.profileData.fullname = nameTxtField.text!
        localData.profileData.username = userNameTxtField.text!
        CurrentSession.getI().saveData()
    }
    
    
    func show(image: UIImage) {
        
        profileImage.image = image
        profileImage.isHidden = false
        profileImage.layer.cornerRadius = profileImage.layer.borderWidth/2
        profileImage.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
    }
    
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    
    func showPhotoMenu() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.takePhotoWithCamera()
        })
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
            self.choosePhotoFromLibrary()
        })
        alert.addAction(actLibrary)
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK:- Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        
        if let theImage = image {
            let resizedImage = resizeImage(image: theImage, targetSize: CGSize.init(width: 200, height: 250))
            
            show(image: resizedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Compress
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func convertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    
}

