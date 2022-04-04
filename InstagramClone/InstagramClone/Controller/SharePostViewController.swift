//
//  SharePostViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 10/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit
import FirebaseStorage
import Photos
import FirebaseDatabase

class SharePostViewController:BaseViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    //Variables
    var imgo = ""
    var image: UIImage?
    var emptyUrl:URL?
    var imgDownloadUrl: String?
    var likeCount = [String]()
    var imagecreation = Date()
    var postTime = ""
    
    //Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var captionTxtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "SharePost"
        initView()
    }
}

extension SharePostViewController {
    
    // Button Actions
    
    func initView(){
        
        username.text = self.localData.profileData.username
        
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let result1 = formatter.string(from: date)
        currentDate.text = result1
        
//        if localData.profileData.profilepic == ""{
//            imageView.image =  UIImage(named: "icons8-image-file-add-64")
//
//        }else{
//
//            imageView.downloadImage(from: self.localData.profileData.profilepic)
//        }
        
        imageView.image =  UIImage(named: "icons8-image-file-add-64")
        
         imageView.contentMode = .scaleToFill
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @IBAction func sharePostBtnPressed(_ sender: Any) {
        sharePost()
    }
    
    
    func sharePost() {
        if (self.captionTxtView.text == "" || self.imageView.image == nil){
            
            return
        }
        let timeInterval = NSDate().timeIntervalSince1970
        let activityNode = self.ref.child("users").child(self.localData.fireUserId).child("activity").childByAutoId()
        let key  = activityNode.key
        let uid = localData.fireUserId
        let storage = Storage.storage().reference(forURL: "gs://capstone-22743.appspot.com")
        
        
        let imageRef = storage.child("posts").child(uid).child("\(String(describing: key)).jpg")
        
        let data = self.imageView.image!.jpegData(compressionQuality: 0.6)
        
        let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if self.localData.profileData.username == ""{
                self.localData.profileData.username = "YXZ"
            }else{
                self.localData.profileData.username = self.localData.profileData.username
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["authorID" : uid,
                                "image" : url.absoluteString,
                                "likes" : 0,
                                "caption":self.captionTxtView.text!,
                                "likeCount": ["":""],
                                "authorName" : self.localData.profileData.username,
                                "postTime":timeInterval,
                                "postID" : key!] as [String : Any]
                    
                    activityNode.updateChildValues(feed)
                    self.loginAlert(title: "IMAGE", msg: "Imaage Uploaded successfully"){
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            })
            
        }
        
        uploadTask.resume()
        
//        self.ref.child("likes").child(self.localData.fireUserId).child("likeCount")
//        self.ref.child("likes").child(self.localData.fireUserId).child("isLiked")
        
    }
    
    // Upload image functions
    @objc func handleTap() {
        pickPhoto()
    }
    
    func uploadImage(_ image:UIImage,completion: @escaping ((_ url: URL?) -> ())){
        let storageRef = Storage.storage().reference().child("image.png")
        let imgData = imageView.image?.jpegData(compressionQuality: 0.6)
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        storageRef.putData(imgData!, metadata: metaData) { (metadata, error) in
            if error == nil{
                print("success")
                storageRef.downloadURL{ (url, error) in
                    completion(url!)
                }
            }else{
                print("error", error!)
                completion(nil)
            }
        }
    }
    
    func saveImage(profile:URL,completion: @escaping ((_ url: URL?) -> ())){
        let dict = ["profileUrl":profile.absoluteString] as [String:Any]
        self.ref.child("users").childByAutoId().child("activity").setValue(dict)
        
    }
    
    func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        //imageView.layer.cornerRadius = imageView.layer.borderWidth/2
       // imageView.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
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
}
