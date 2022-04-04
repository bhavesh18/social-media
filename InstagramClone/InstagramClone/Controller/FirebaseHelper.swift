//
//  FirebaseHelper.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 11/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper
import UIKit
import ANLoader


class FireBaseHelper{
    
    
    var postID = ""
    var authorId = ""
    
    var databaseHandle = DatabaseHandle()
    static let ref = Database.database().reference()
    var localData = CurrentSession.getI().localData
    
    //For Login
    
    func authenticateUser(email: String,password: String, onCompletion: @escaping (Bool) -> ()){
        var doesUserExist = false
        FireBaseHelper.ref.child("users").queryOrderedByKey().observe(.value) { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
//                print(snapshot.count)
                for snap in snapshot{
                    
                    if let userList = snap.value as? [String: Any]{
                        let mappedData = Mapper<UserWrapperData>().mapArray(JSONArray: [userList])
                        
                        if let first = mappedData.first{
                            dump(first.profile)
                            if(first.profile.email == email &&  first.profile.password == password){
                                
                                doesUserExist = true
                                
                                self.localData.fireUserId = snap.key
                                self.localData.userName = first.profile.username
                                self.localData.profileData.userPhoneNumber = first.profile.userPhoneNumber
                                self.localData.profileData.userGender = first.profile.userGender
                                self.localData.profileData.userBio = first.profile.userBio
                                self.localData.profileData.fullname = first.profile.fullname
                                self.localData.profileData.profilepic = first.profile.profilepic
                                self.localData.profileData.email = first.profile.email
                                self.localData.profileData.username = first.profile.username

                                self.localData.snapshot = Int(snap.children.allObjects.count)
                                CurrentSession.getI().saveData()
                                
                            }
                        }
                    }
                }
                
                onCompletion(doesUserExist)
            }
        }
        FireBaseHelper.ref.removeAllObservers()
    }
    
    
    // Getting All posts
    
    func getActivityData(onCompletion: @escaping ([UserActivityData]) -> ()){
       
        let id = CurrentSession.getI().localData.fireUserId
//        print(CurrentSession.getI().localData.snapshot)
        if CurrentSession.getI().localData.snapshot <= 0{
            //   return
        }
        FireBaseHelper.ref.child("users").child(id).child("activity").queryOrderedByKey().observe(.value) { (snapshot) in
             
            var arr:[UserActivityData] = []
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
//                print(snapshot.count)
                
                for snap in snapshot{
//                    print(snap.key)
                    if let data = snap.value as? [String: Any]{
                       
                        let mappedData = Mapper<UserActivityData>().mapArray(JSONArray: [data])
                        
                        if let first = mappedData.first{
                            first.id = snap.key
                            
                            arr.append(first)
                            dump(first.image + " *** " + snap.key)
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
    
    // getting multiple users
    
    func getUsers(onCompletion: @escaping ([UserRootdata]?) -> ()){
       
        FireBaseHelper.ref.child("users").queryOrderedByKey().observe(.value) { (snapshot) in
//            ANLoader.showLoading()
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                var list:[UserRootdata] = []
                for snap in snapshot{
                    
                    if let userList = snap.value as? [String: Any]{
                        
                        dump(userList)
                        if let mappedData = Mapper<UserWrapperData>().map(JSON: userList){
                            let obj = UserRootdata()
                            obj.userId = snap.key
                            obj.userWrapperData = mappedData
                            list.append(obj)
                            ANLoader.hide()
                        }
                        
                    }
                }
                onCompletion(list)
            }
        }
        
    }
    
    //Getting single user
    
    func getUser(userId:String,onCompletion: @escaping (UserRootdata?) -> ()){
        getUsers { (users) in
            if let list = users{
                for item in list{
                    if item.userId == userId{
                        onCompletion(item)
                        break
                    }
                }
            }
        }
        
    }
    
    
    // For getting Comments
    func getPostCommentData(onCompletion: @escaping ([CommentData]) -> ()){
       
        let activityNode = FireBaseHelper.ref.child("users").child(localData.fireUserId).child("activity").child(localData.postId)
        
        activityNode.child("commentCount").queryOrderedByKey().observe(.value) { (snapshot) in
            var arr:[CommentData] = []
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
//                print(snapshot.count)
                
                for snap in snapshot{
//                    print(snap.key)
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

