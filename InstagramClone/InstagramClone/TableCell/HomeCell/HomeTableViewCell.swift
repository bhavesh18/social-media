
//  HomeTableViewCell.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 11/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
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
    var likedCell: ((Int)->())? = nil
    
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
        
        onLikeTap()
    }
    
    @IBAction func commentBtnTapped(_ sender: Any) {
        
        delegate.commentTableCell(cell: self, index: index)
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        delegate.share(cell: self, index: index)
    }
    
    func onLikeTap(){
        
        DispatchQueue.main.async {
            CurrentSession.getI().isLiking = true
            CurrentSession.getI().saveData()
            
            var doLike = true
            
            let likeCount = self.ref.child("users").child(self.authorID).child("activity").child(self.postID)
            
            likeCount.child("likeCount").observeSingleEvent(of: .value) { [weak self] lc in
                guard let ss = self else{return}
                
                if let dictionary = lc.value as? [String: Any]{
                    let likedByUsersId: [String] = dictionary.map{String($0.key) }
                    
                    print(likedByUsersId)
                    
                    for liked in likedByUsersId{
                        print("doLike allPostid: ",liked)
                        if(liked == ss.authorID){
                            doLike = false
                        }
                    }
                }
                
                print("postid: ", ss.postID)
                print("authorid: ", ss.authorID)
                print("doLike final: ", doLike, " postID: " ,ss.authorID)
                
                let likeCount = ss.ref.child("users").child(ss.authorID).child("activity").child(ss.postID)
                
                if(doLike){
                    //like
                    
                    let data = ["authorid":ss.authorID,"authorNameWhoLike":ss.localData.userName]
                    
                    likeCount.child("likeCount").child(ss.authorID).setValue(data)
                }else{
                    //unlike
                    likeCount.child("likeCount").child(ss.authorID).removeValue()
                }
                
                
            }
            
            //For liking the post
            let activityNode = self.ref.child("users").child(self.authorID).child("activity").child(self.postID)
            
            
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.imagePosted.image = nil
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        
        tap1.numberOfTapsRequired = 2
        self.imagePosted.isUserInteractionEnabled = true
        self.imagePosted.addGestureRecognizer(tap1)
        
    }
    
    @objc func doubleTapped() {
        
        print("double tapped")
        self.onLikeTap()
        
    }
}
