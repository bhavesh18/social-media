//
//  PopUpViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 17/04/20.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper
import ANLoader

class PopUpViewController: BaseViewController {
    
    var postID = ""
    var authorID = ""
    let keyToPost = CurrentSession.getI().localData.fireUserId
    var usersCommentList:[CommentData] = []
    var noData = false
    
    
    @IBOutlet weak var currentUserImg:UIImageView!
    @IBOutlet weak var commentTxtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func postCommentBtnTapped(_ sender: Any) {
        if isEmpty().empty{
            loginAlert(title: "", msg: isEmpty().msg)
        }else{
            commentToPost()
                  tableView.isHidden = false
                  tableView.reloadData()
        }
        
      
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.title =  "Comments"

        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        initView()
    }
}


extension PopUpViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (usersCommentList.count <= 0){
            tableView.isHidden = true
        }else{
            tableView.isHidden = false
            
        }
        
        return  usersCommentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var currentCell = UITableViewCell()
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell{
            
            cell.commentUserName.text = usersCommentList[indexPath.row].commentuserName
            cell.userComment.text = usersCommentList[indexPath.row].currentUserId
           cell.commentUserImg.contentMode = .scaleToFill
            if self.usersCommentList[indexPath.row].commentUserimg == ""{
                cell.commentUserImg.image = UIImage(named: "baseline_account_circle_white_24pt")
                
            }else{
                cell.commentUserImg.downloadImage(from: self.usersCommentList[indexPath.row].commentUserimg)
            }
            currentCell =  cell
            
        }
        return currentCell
        
    }
}


extension PopUpViewController{
    
    /* ------------   all functions and Button actions --------------  */
    
    func initView(){
        
        let nib1 = UINib.init(nibName: "CommentTableViewCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "CommentTableViewCell")
        let nib = UINib.init(nibName: "NoCommentCellViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "NoCommentCellViewCell")
        
        self.navigationItem.title = "Comments"
        self.getPostCommentData { (commentList) in
            // self.firebaseHelper.getPostCommentData { (commentList) in
            self.usersCommentList = commentList
            self.tableView.reloadData()
            
        }
        
        if localData.profileData.profilepic == ""{
            
            currentUserImg.image = UIImage(named: "baseline_account_circle_white_24pt")
            
        }else{
            currentUserImg.downloadImage(from: localData.profileData.profilepic)
        }
    }
    
    //Mark: Empty validatons
     
     func isEmpty() -> (msg: String,empty: Bool) {
         
         if commentTxtField.text == ""{
             return("Comment Field is empty",true)
         }
        
         return("",false)
         
     }
    
    //Saving data to firebase
    
    func commentToPost (){
        
        let ref = Database.database().reference()
        
        //For Commenting the post
        let activityNode = ref.child("users").child(self.authorID).child("activity").child(postID)
        
        activityNode.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                _ = properties["commentCount"] as? [String:AnyObject]
                activityNode.child("commentCount").childByAutoId().setValue(["comment":self.commentTxtField.text!,"commentAuthorName":self.localData.profileData.username,"postId":self.postID,"commentUserimg":self.localData.profileData.profilepic])
                self.getPostCommentData { (commentList) in
                    self.usersCommentList = commentList
                    self.tableView.reloadData()
                }
            }
        })
        ref.removeAllObservers()
    }
    
    // fetching comment data
    func getPostCommentData(onCompletion: @escaping ([CommentData]) -> ()){
        let activityNode = ref.child("users").child(self.authorID).child("activity").child(postID)
        
        
        activityNode.child("commentCount").queryOrderedByKey().observe(.value) { (snapshot) in
            var arr:[CommentData] = []
            arr.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                print(snapshot.count)
                
                for snap in snapshot{
                    print(snap.key)
                    if let data = snap.value as? [String: Any]{
                        let mappedData = Mapper<CommentData>().mapArray(JSONArray: [data])
                        
                        if let first = mappedData.first{
                            first.id = snap.key
                            
                            arr.append(first)
                            
                            CurrentSession.getI().localData.postId.append(snap.key)
                            CurrentSession.getI().localData.snapshot = Int(snap.children.allObjects.count)
                            CurrentSession.getI().saveData()
                            
                        }
                    }
                }
            }else{
                print("no data")
            }
            onCompletion(arr)
        }
    }
    
    
}

