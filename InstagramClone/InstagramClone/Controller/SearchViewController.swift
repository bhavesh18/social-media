//
//  SearchViewController.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 09/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookLogin
import Firebase
import FirebaseDatabase
import ObjectMapper

class SearchViewController: BaseViewController {
    
    var filterArray:[UserRootdata] = []
    var usersList:[UserRootdata] = []
    var singleUserfilterArray:[UserWrapperData] = []
    var username = ""
    var userId: String?
    var noData = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var resultCountLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initViewData()
    }
}


extension SearchViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.isEmpty){
         filterArray = []
           

        }else{
            filterArray = usersList.filter({ (data) -> Bool in
                username = data.userWrapperData.profile.username
                return data.userWrapperData.profile.username.range(of: searchText, options: .caseInsensitive) != nil
                
            })
        }
        
        
        if filterArray.count <= 0{
            tableView.isHidden = true
        }else{
            tableView.isHidden = false
        }
        self.searchBar.endEditing(true)
        self.resultCountLbl.text = "No. of Result: \(self.filterArray.count)"
        tableView.reloadData()
    }
}

extension SearchViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var currentcell = UITableViewCell()
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell{
            cell.heading.text =  filterArray[indexPath.row].userWrapperData.profile.username
            cell.profilepic.contentMode = .scaleToFill
            if filterArray[indexPath.row].userWrapperData.profile.profilepic == ""{
                cell.profilepic.image = #imageLiteral(resourceName: "baseline_account_circle_white_24pt")
            }else{
                cell.profilepic.downloadImage(from: filterArray[indexPath.row].userWrapperData.profile.profilepic)
            }
            currentcell = cell
        }
        return currentcell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userId = filterArray[indexPath.row].userId
        // Single
        
        firebaseHelper.getUser(userId: userId) { (data) in
            
            self.singleUserfilterArray.append(data!.userWrapperData)
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController {
                viewController.userId = userId
                viewController.filterArray = self.singleUserfilterArray
                if let navigator = self.navigationController{
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
    }
}

extension SearchViewController{
    
    /* All Functions */
    
    func initViewData(){
        
        self.navigationItem.title = "Search"
        
        firebaseHelper.getUsers { (users) in
            if let data = users{
                self.usersList = data
                self.filterArray = self.usersList
                self.resultCountLbl.text = "No. of Result: \(self.filterArray.count)"
                self.tableView.reloadData()
            }
            dump(users)
        }
        
        // Single
        if let userid = userId{
            firebaseHelper.getUser(userId: userid) { (data) in
                
                self.singleUserfilterArray.append(data!.userWrapperData)
                
            }
        }
        
        
        LoginManager().logOut()
        
        let nib1 = UINib.init(nibName: "NoDataCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "NoDataCell")
        
        let nib = UINib.init(nibName: "SearchCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "SearchCell")
    }
}
