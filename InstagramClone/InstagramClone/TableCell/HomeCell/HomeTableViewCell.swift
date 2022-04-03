
//  HomeTableViewCell.swift
//  InstagramClone
//
//  Created by Dharam Singh on 11/03/20.
//  Copyright © 2020 Dharam Singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import ANLoader

class HomeTableViewCell: UITableViewCell {
    
    var isLikeBtn = false
    var delegate: HomePageProtocol!
    var likeCounter = [String]()
    var index = 0
    var totalLikeCount = 0
    var postID = ""
    var authorID = ""
    var localData = CurrentSession.getI().localData
    var ifAlreadyLiked = false
    var count = 0
    let ref = Database.database().reference()
    let keyToPost = CurrentSession.getI().localData.fireUserId
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var postTIme: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var imagePosted: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var captionLbl: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var likeBtnCount: UIButton!
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        
        //        print(self.authorID)
        //        print(self.postID)
        //        print(self.localData.fireUserId)
        
        //        onLikeTap()
        
        DispatchQueue.main.async {
            
            //For liking the post
            let activityNode = self.ref.child("users").child(self.authorID).child("activity").child(self.postID)
            
            self.ref.child("users").child(self.authorID).child("activity").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                //            print(snapshot)
                if let _ = snapshot.value as? [String : AnyObject] {
                    //                print(post)
                    
                    if let properties = snapshot.value as? [String : AnyObject] {
                        //                    print(properties)
                        
                        if self.ifAlreadyLiked == false{
                            
                            if let likes = properties["likeCount"] as? [String:AnyObject]{
                                print(likes.count)
                                activityNode.child("likeCount").child(self.localData.fireUserId).setValue(["authorid":self.localData.fireUserId,"authorNameWhoLike":self.localData.userName])
                                
                                self.ifAlreadyLiked = true
                            }else{
                                activityNode.child("likeCount").child(self.localData.fireUserId).setValue(["authorid":self.localData.fireUserId,"authorNameWhoLike":self.localData.userName])
                                
                            }
                        }else{
                            
                            //For unlike the  post
                            
                            let activityNode = self.ref.child("users").child(self.authorID).child("activity").child(self.postID)
                            
                            activityNode.observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                if let properties = snapshot.value as? [String : AnyObject] {
                                    if let peopleWhoLike = properties["likeCount"] as? [String : AnyObject] {
                                        //                                    print(peopleWhoLike)
                                        activityNode.child("likeCount").child(self.localData.fireUserId).removeValue(completionBlock: { (error, reff) in
                                            if error == nil {
                                                activityNode.observeSingleEvent(of: .value, with: { (snap) in
                                                    if let prop = snap.value as? [String : AnyObject] {
                                                        if let likes = prop["likeCount"] as? [String : AnyObject] {
                                                            print(likes)
                                                            
                                                            activityNode.child("likeCount").updateChildValues(["": ""])
                                                            
                                                            
                                                        }else {
                                                            activityNode.child("likeCount").updateChildValues(["": ""])
                                                            
                                                        }
                                                    }
                                                })
                                            }
                                        })
                                    }
                                }
                            })
                            self.ref.removeAllObservers()
                            self.ifAlreadyLiked = false
                        }
                    }
                }
            })
            
            activityNode.child("likeCount").observe(.value, with: { (snapshot: DataSnapshot!) in
                print("Got snapshot");
                //            print(snapshot.childrenCount)
                activityNode.updateChildValues(["likes" : snapshot.childrenCount])
                self.likeBtnCount.setTitle("\(snapshot.childrenCount ) Likes", for: .normal)
            })
            
            ANLoader.hide()
            self.ref.removeAllObservers()
        }
    }
    
    @IBAction func commentBtnTapped(_ sender: Any) {
        
        delegate.commentTableCell(cell: self, index: index)
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        delegate.share(cell: self, index: index)
    }
    
    func onLikeTap(){
        //        ref.child("likes").child().child("activity").child(postID)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        imagePosted.addGestureRecognizer(tap)
    }
    
    @objc func doubleTapped() {
        
        // do something here
        delegate.commentTableCell(cell: self, index: index)
        print("double tapped")
        
    }
}
