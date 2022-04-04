//
//  ViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 06/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
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
        print(localData.fireUserId) //user id
        
        CurrentSession.getI().isLiking = false
        CurrentSession.getI().saveData()
        
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let result1 = formatter.string(from: date)
        
        print(result1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initViewData()
    }
    
    
    @IBAction func onAddTap(_ sender: UIBarButtonItem) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SharePostViewController") as? SharePostViewController {
            
            if let navigator = self.navigationController{
                navigator.pushViewController(viewController, animated: true)
            }
        }
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
            cell.index = indexPath.row
            cell.captionLbl.text = allUsersActitivtyList[indexPath.row].caption
            cell.userNameLbl.text = allUsersActitivtyList[indexPath.row].authorName
            cell.postID = self.allUsersActitivtyList[indexPath.row].postID
            //            localData.postId = self.allUsersActitivtyList[indexPath.row].postID
            cell.authorID = self.allUsersActitivtyList[indexPath.row].authorID
            //            localData.postAuthorId = self.allUsersActitivtyList[indexPath.row].authorID
            cell.profilePic.contentMode = .scaleAspectFill
            cell.imagePosted.contentMode = .scaleAspectFill
//            cell.likeBtn.tintColor = .black
            
            if let i = usersList.firstIndex(where: { $0.userId == self.allUsersActitivtyList[indexPath.row].authorID}){
                
                if usersList[i].userWrapperData.profile.profilepic == ""{
                    cell.profilePic.image =  UIImage(named: "baseline_account_circle_white_24pt")
                }else{
                    
                    cell.profilePic.load(urlStr: self.usersList[i].userWrapperData.profile.profilepic)

                }
                
            }
            
            cell.imagePosted.image = nil
            cell.imagePosted.load(urlStr: self.allUsersActitivtyList[indexPath.row].image)
            
            cell.likeBtnCount.setTitle("\(allUsersActitivtyList[indexPath.row].likes) Likes", for: .normal)
            
            
            let likedByUsersId = self.allUsersActitivtyList[indexPath.row].likeCount.map({$0.key})
            
            var isLiked = false
            for liked in likedByUsersId{
                if(liked == self.localData.fireUserId){
                    isLiked = true
                }
            }
            print("cell: ", indexPath.row ,isLiked ? " MATCHED" : "No MATCH")
            cell.likeBtn.tintColor = isLiked ? .red : .black
            
            currentCell = cell
        }
        return currentCell
    }
    
    
}

extension HomeViewController: HomePageProtocol{
    
    func share(cell: HomeTableViewCell, index: Int) {
        
        if let indexpath = tableView.indexPath(for: cell){
            
            let text = allUsersActitivtyList[indexpath.row].caption
            let image =  self.allUsersActitivtyList[indexpath.row].image
            
            let shareAll = [text , image ] as [Any]
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
            
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func imageDoubleTapped(cell: HomeTableViewCell) {
        self.tableView.reloadData()
        print("image")
        
    }
    
    func hometableCell(cell: HomeTableViewCell) {
        print("likeeeeee")
        
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
//            self.showLoader()
            if let data = users{
                print("List Users updated########===")

                self.usersList.removeAll()
                self.allUsersActitivtyList.removeAll()
                self.usersList = data

                for item in 0..<self.usersList.count{
                    let data = self.usersList[item].userWrapperData
                                                            
                    for (_,value) in data.activity{
                        print(value.likeCount)
                        self.allUsersActitivtyList.append(value)
                        ANLoader.hide()
                    }
                    self.allUsersActitivtyList = self.allUsersActitivtyList.sorted(by: { $0.postTime > $1.postTime })

                }
            }
            
//            if(CurrentSession.getI().isLiking){
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    CurrentSession.getI().isLiking = false
//                    CurrentSession.getI().saveData()
//                    print("Reloading tableview data stopped")
//                }
//            }else{
//                print("Reloading tableview data")
//                self.tableView.reloadData()
//            }
            
//            self.hideLoader()
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

