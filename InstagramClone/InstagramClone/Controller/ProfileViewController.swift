//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 07/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import ObjectMapper
import ANLoader
import GoogleMobileAds

class ProfileViewController: BaseViewController,GADBannerViewDelegate {
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var collectionViewFlowLayout: UICollectionViewFlowLayout!
    var activityList = [UserActivityData]()
    
    @IBOutlet weak var nopostImg: UIImageView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var totalPostLbl: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileBioLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        totalPostLbl.text = " No of Posts: \(activityList.count)"
    }
    
    
    // MARK: - GADBannerViewDelegate
    // Called when an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    // Called when an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(#function): \(error.localizedDescription)")
    }
    
    // Called just before presenting the user a full screen view, such as a browser, in response to
    // clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    // Called just before dismissing a full screen view.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    // Called just after dismissing a full screen view.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print(#function)
    }
    
    // Called just before the application will background or terminate because the user clicked on an
    // ad that will launch another application (such as the App Store).
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print(#function)
    }
}

// Collection view functions

extension ProfileViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          if (activityList.count <= 0){
                  collectionView.isHidden = true
            nopostImg.isHidden = false
              }else{
                  collectionView.isHidden = false
                 nopostImg.isHidden = true
              }
        return  activityList.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilecell", for: indexPath) as? ProfileCollectionViewCell{
            
            if self.activityList[indexPath.row].image == ""{
                cell.imageView.image =  UIImage(named: "baseline_account_circle_white_24pt")
            }else{
                cell.imageView.downloadImage(from: activityList[indexPath.row].image)
            }
            return cell
        }
        return currentCell
    }
}


class ProfileCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    
}



extension ProfileViewController {
    
    //Button Actions
        
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "EditViewController") as! EditViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    // Functions
    func initView(){
        
        self.navigationItem.title = localData.profileData.username
        if localData.profileData.username == ""{
            localData.profileData.ifUsernameEmpty = true
        }else{
            localData.profileData.ifUsernameEmpty = false
        }
        collectionviewLayout()
        
        bannerView.delegate = self
               bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
               bannerView.rootViewController = self
               bannerView.load(GADRequest())
        
        usernameLbl.text = localData.profileData.fullname
        totalPostLbl.text = " No of Posts: \(activityList.count)"
        profileBioLbl.text =  localData.profileData.userBio
        
        //profile bio from firebase is empty
        if localData.profileData.userBio == ""{
            profileBioLbl.text = "Nothing to show"
        }else{
            profileBioLbl.text = localData.profileData.userBio
        }
        
        if ((localData.profileData.profilepic) != "") {
            profilePic.downloadImage(from: self.localData.profileData.profilepic)
        }
        
        //Post of all users
        firebaseHelper.getActivityData { (activitylist) in
            self.activityList.removeAll()
            self.activityList = activitylist
            self.collectionView.reloadData()
        }
    }
    
    func collectionviewLayout(){
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20) / 2 , height: self.collectionView.frame.size.height/3)
        
        // collectionView!.collectionViewLayout = layout
        
    }
    
    func collectionviewLayoutTwo(){
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: width / 2 , height: width / 2)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
        
    }
    
}
