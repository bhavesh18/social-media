//
//  UserViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 17/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit
import ObjectMapper
import GoogleMobileAds

class UserViewController: BaseViewController ,GADBannerViewDelegate{
    
    var userId: String?
    var filterArray:[UserWrapperData] = []
    var activities:[UserActivityData] = []
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postCount: UILabel!
    @IBOutlet weak var userbio: UILabel!
    
    @IBOutlet weak var nopostimg: UIImageView!
    @IBOutlet weak var userProfileImg: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initView()
    }
}

extension UserViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (activities.count <= 0){
            collectionView.isHidden = true
            nopostimg.isHidden = false
        }else{
            collectionView.isHidden = false
            nopostimg.isHidden = true
        }
        return  activities.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var currentCell = UICollectionViewCell()
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendProfileCell", for: indexPath) as? FriendProfileCell{
            
            
            self.postCount.text = " No of Posts: \(activities.count)"
            if let url = URL(string: activities[indexPath.row].image){
                let data = try? Data(contentsOf: url)
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    cell.userImage.image = image
                }
                
            }
            currentCell = cell
        }
        return currentCell
    }
}

class FriendProfileCell: UICollectionViewCell{
    
    @IBOutlet weak var userImage: UIImageView!
}


extension UserViewController{
    
    func collectionviewLayout(){
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20) / 2 , height: self.collectionView.frame.size.height/3)
        
    }
    
    func initView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        fetchSearchUserData()
    }
    
    
    /* ------------ Getting Search user data ---------*/
    func fetchSearchUserData(){
        
        if let userid = userId {
            
            firebaseHelper.getUser(userId: userid) { (d) in
                
                if let data = d {
                    
                    self.navigationItem.title = data.userWrapperData.profile.username
                    self.userNameLbl.text = data.userWrapperData.profile.username
                    self.userbio.text = data.userWrapperData.profile.userBio
                    
                    for (key,value) in data.userWrapperData.activity{
                        let activity = UserActivityData()
                        activity.id = key
                        activity.caption = value.caption
                        activity.image = value.image
                        
                        self.activities.append(activity)
                    }
                    
                    self.collectionView.reloadData()
                    
                    if let url = URL(string: (data.userWrapperData.profile.profilepic)){
                        let data = try? Data(contentsOf: url)
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            self.userProfileImg.image = image
                        }
                    }else{
                        self.userProfileImg.image = #imageLiteral(resourceName: "baseline_account_circle_white_24pt")
                        self.userProfileImg.image = self.userProfileImg.image?.withRenderingMode(.alwaysTemplate)
                        self.userProfileImg.tintColor = Constants.btnColor
                    }/* Url if let ends Here */
                    
                }/*   data = d ends Here  */
                
            }
        }/*userid = userId Ends Here */
        
    }
    
}
