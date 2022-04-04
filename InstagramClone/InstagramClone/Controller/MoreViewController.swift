//
//  MoreViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 30/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase
class MoreViewController: BaseViewController,GADBannerViewDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var userprofilepic: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewData()
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

extension MoreViewController{
    
    /* ------------- All functions and Button Actions -------------- */
    
    func initViewData(){
        self.navigationItem.title = "More"
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        usernameLbl.text = self.localData.profileData.username
        
        
        if localData.profileData.profilepic == ""{
            userprofilepic.image =  UIImage(named: "baseline_account_circle_white_24pt")
            
        }else{
            
            userprofilepic.downloadImage(from: self.localData.profileData.profilepic)
        }
        userprofilepic.contentMode = .scaleToFill
        
    }
    
    func logoutDataView(){
        
        let vc = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        
        localData.profileData.userBio = ""
        localData.userName = ""
        localData.profileData.fullname = ""
        localData.profileData.userPhoneNumber = ""
        localData.profileData.username = ""
        
        localData.profileData.userGender = ""
        localData.postId = ""
        localData.postAuthorId = ""
        localData.fireUserId = ""
        localData.profileData.profilepic = ""
        localData.isLogged = false
        localData.socialLogin = false
        localData.isFirstFbLogin = false
        // try! Auth.auth().signOut()
        CurrentSession.getI().saveData()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func aboutusBtnTapped(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(identifier: "AboutViewController") as? AboutViewController{
            
            if let navigator = self.navigationController{
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func helpUsBtnTapped(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(identifier: "HelpViewController") as? HelpViewController{
            
            if let navigator = self.navigationController{
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func sharePostBtnTapped(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SharePostViewController") as? SharePostViewController {
            
            if let navigator = self.navigationController{
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
        logoutDataView()
    }
}
