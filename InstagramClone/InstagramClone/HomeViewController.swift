//
//  ViewController.swift
//  InstagramClone
//
//  Created by Dharam Singh on 06/02/20.
//  Copyright © 2020 Dharam Singh. All rights reserved.
//

import UIKit
import ANLoader

class HomeViewController: BaseViewController {
    
    var activityList = [UserActivityData]()
    var allUsersActitivtyList = [UserActivityData]()
    var usersList:[UserRootdata] = []
    var index = 0
    var postIsAlreadyLiked = false
    
    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentUserPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(localData.postAuthorId)
        print(localData.postId)
        print(localData.fireUserId)
        
       

       formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let result1 = formatter.string(from: date)

        print(result1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        initViewData()
    }
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
}

extension HomeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsersActitivtyList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var currentCell = UITableViewCell()
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell{
         
            cell.delegate = self
            cell.captionLbl.text = allUsersActitivtyList[indexPath.row].caption
            cell.userNameLbl.text = allUsersActitivtyList[indexPath.row].authorName
            cell.postID = self.allUsersActitivtyList[indexPath.row].postID
            localData.postId = self.allUsersActitivtyList[indexPath.row].postID
            cell.authorID = self.allUsersActitivtyList[indexPath.row].authorID
            localData.postAuthorId = self.allUsersActitivtyList[indexPath.row].authorID
            cell.profilePic.contentMode = .scaleToFill
            cell.imagePosted.contentMode = .scaleToFill
//            cell.imagePosted.image = nil
            for i in 0..<usersList.count{
                
                print(self.usersList[i].userWrapperData.profile.profilepic)
                
                if self.allUsersActitivtyList[indexPath.row].authorID == usersList[i].userId{
                    if self.usersList[i].userWrapperData.profile.profilepic == ""{
                        cell.profilePic.image =  UIImage(named: "baseline_account_circle_white_24pt")
                    }else{
                        
                        
                        cell.profilePic.downloadImage(from: self.usersList[i].userWrapperData.profile.profilepic)
                    }
                }
            }
            
        
            if let url = URL(string: self.allUsersActitivtyList[indexPath.row].image){
                let data = try? Data(contentsOf: url)
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    
                    cell.imagePosted.image = image
                }
            }
            
            cell.likeBtnCount.setTitle("\(allUsersActitivtyList[indexPath.row].likes) Likes", for: .normal)
            
            let activityNode = ref.child("users").child(self.allUsersActitivtyList[indexPath.row].authorID).child("activity").child(self.allUsersActitivtyList[indexPath.row].postID).child("likeCount")
            
            activityNode.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(self.localData.fireUserId){
                    print("true rooms exist")
                    cell.likeBtn.tintColor = .red
                    
                }else{
                    print("false room doesn't exist")
                    cell.likeBtn.tintColor = .white
                }
            })
            ref.removeAllObservers()
            CurrentSession.getI().saveData()
            currentCell = cell
        }
        return currentCell
    }
    
    
}

extension HomeViewController: HomePageProtocol{
    
    func share(cell: HomeTableViewCell, index: Int) {
        
        if let indexpath = tableView.indexPath(for: cell){
            
            let text = allUsersActitivtyList[indexpath.row].caption
            let image =  self.allUsersActitivtyList[indexpath.row].image //UIImage(named: self.allUsersActitivtyList[indexpath.row].image)
            print(image)
            print(text)
            let shareAll = [text , image ?? "" ] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    func commentTableCell(cell: HomeTableViewCell, index: Int) {
        
        
        
        if let indexpath = tableView.indexPath(for: cell){
            print("comment")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
            vc.postID = self.allUsersActitivtyList[indexpath.row].postID
            vc.authorID = self.allUsersActitivtyList[indexpath.row].authorID
            
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func imageDoubleTapped(cell: HomeTableViewCell) {
        self.tableView.reloadData()
        print("image")
        
    }
    
    func hometableCell(cell: HomeTableViewCell) {
        print("like")
        
        self.tableView.reloadData()
    }
    
    
    func btnCloseTapped(cell: HomeTableViewCell) {
        //Get the indexpath of cell where button was tapped
    }
}


class CollectionViewCell: UICollectionViewCell{
    
    
}
class TableviewCell: UITableViewCell {
    
}
extension HomeViewController{
    
    // all functions
    
    func initViewData(){
        self.navigationItem.title = "Social Media"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Give the format you want to the formatter:
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        // Get the result string:
        let result = formatter.string(from: date)
        todayDate.text = result.uppercased()
        
        let nib1 = UINib.init(nibName: "HomeTableViewCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "HomeTableViewCell")
        
        firebaseHelper.getUsers { (users) in
            
            if let data = users{
                
                self.usersList = data
                self.allUsersActitivtyList.removeAll()
                for item in 0..<self.usersList.count{
                    let data = self.usersList[item].userWrapperData
                    
                    for (_,value) in data.activity{
                        self.allUsersActitivtyList.append(value)
                        ANLoader.hide()
                    }
                }
            }
            dump(users)
            self.tableView.reloadData()
        }
        
        if localData.profileData.profilepic == ""{
            currentUserPic.image = UIImage(named: "baseline_account_circle_white_24pt")
            currentUserPic.image =   currentUserPic.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            
            
        }else{
            currentUserPic.downloadImage(from: self.localData.profileData.profilepic)
            
        }
        currentUserPic.contentMode = .scaleToFill

    }
    
    
}


extension Date {
    func timeAgoDisplay() -> String {
        let date = Date().addingTimeInterval(self.timeIntervalSinceNow)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
