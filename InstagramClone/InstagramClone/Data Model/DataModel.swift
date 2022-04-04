//
//  DataModel.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 11/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import Foundation
import ObjectMapper

// Data types....

class BaseData: Mappable{
    var id = ""
    
    init(){
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
    }
    
    func isReadyToSave() -> String {
        //preconditionFailure("overrider it")
        return ""
    }
    
    func getCombineString() -> String {
        return  id
    }
    
    func update(_ data :BaseData , isForce :Bool = false){
        id = data.id != "" || isForce ? data.id : id
    }
    
}


extension BaseData : Hashable {
    
    var hashValue: Int {
        return getCombineString().hashValue
    }
    
}

extension BaseData : Equatable {}

func == (lhs: BaseData, rhs: BaseData) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
}

class UserData: BaseData{
    var userID = ""
    var social_id = ""
    
    var login_type = ""
    var full_name = ""
    var phone = ""
    var profession = ""
    var image = ""
    var device_id = ""
    var token = ""
    var device_type = ""
    var is_prod = ""
    var firstName: String! = ""
    var lastName: String! = ""
    var profileImage: String! = ""
    var username: String = ""
    var userType: String = ""
    var aboutMe: String! = ""
    var intersets: Array = [""]
    var isNotify: Bool! = false
    var contact: String! = ""
    var email: String! = ""
    var dob: String! = ""
    var graphQLId: String! = ""
    var gender: String! = ""
    var address: String! = ""
    var city: String! = ""
    var state: String! = ""
    var pincode: String! = ""
    var shortListData: [String]!
    var isPhoneVerified = false
    var isEmailVerified = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        userID <- map["id"]
        social_id <- map["social_id"]
        phone <- map["phone"]
        full_name <- map["full_name"]
        
        
        login_type <- map["login_type"]
        profession <- map["profession"]
        image <- map["image"]
        device_id <- map["device_id"]
        is_prod <- map["is_prod"]
        token <- map["token"]
        device_type <- map["device_type"]
        
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        profileImage <- map["profile_image"]
        aboutMe <- map ["aboutMe"]
        intersets <- map["intersets"]
        username <- map["username"]
        shortListData <- map["shortlistData"]
        contact <- map["contact"]
        if contact == nil {
            contact = ""
        }
        email <- map["email"]
        dob <- map["dob"]
        gender <- map["gender"]
        address <- map["address"]
        city <- map["city"]
        state <- map["state"]
        pincode <- map["pincode"]
        device_id <- map ["device_id"]
        profileImage <- map["profile_img"]
        graphQLId <- map["graphQLId"]
        
        var ip = ""
        var ie = ""
        var n = ""
        n <- map["is_notify"]
        ip <- map["phone_verified"]
        ie <- map["email_verified"]
        
        
        
        if let n = Int(n) {
            if n > 0 {
                isNotify = true
            }
            else {
                isNotify = false
            }
        }
        
        if let p = Int(ip) {
            if p > 0 {
                isPhoneVerified = true
            }
            else {
                isPhoneVerified = false
            }
        }
        
        if let e = Int(ie) {
            if e > 0 {
                isEmailVerified = true
            }
            else {
                isEmailVerified = false
            }
        }
        
    }
    
    override func getCombineString() -> String {
        return userID
    }
    
}

class ProfileData: NSObject, NSCoding {
    
    var id = ""
    var email = ""
    var firstName = "Hello"
    var lastName = "User"
    var aboutMe = ""
    var intersets = [String]()
    var profession = ""
    var profileImage = ""
    var userType = ""
    var device_id = ""
    var zip = ""
    var phone = ""
    var address = "Address"
    var city = ""
    var state = "State"
    var country = ""
    var gender = ""
    var bio = ""
    
    
    var isNotify: Bool = true
    var socialId: String = ""
    var isPhoneVerify: Bool = false
    
    override init() {
        
    }
    
    func update(data : UserData) {
        self.email = data.email ?? ""
        self.firstName = data.firstName ?? ""
        self.lastName = data.lastName ?? ""
        self.profileImage = data.profileImage
        self.intersets = data.intersets
        self.profession = data.profession
        self.userType = data.userType
        self.device_id = data.device_id
        self.aboutMe = data.aboutMe
        
        
        if !(data.userID == "") {
            self.id = data.userID
        }
        
        self.phone = data.contact ?? ""
        self.address = data.address ?? ""
        self.bio = data.dob ?? ""
        self.gender = data.gender ?? ""
        self.city = data.city ?? ""
        self.state = data.state ?? ""
        self.zip = data.pincode ?? ""
        self.socialId = data.graphQLId ?? ""
        self.isPhoneVerify = data.isPhoneVerified
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        self.id = (aDecoder.decodeObject(forKey: "id") as? String) ?? ""
        self.email = (aDecoder.decodeObject(forKey: "email") as? String) ?? ""
        self.firstName = (aDecoder.decodeObject(forKey: "fname") as? String) ?? ""
        self.lastName = (aDecoder.decodeObject(forKey: "lname") as? String) ?? ""
        self.profileImage = (aDecoder.decodeObject(forKey: "profileImage") as? String) ?? ""
        self.userType = (aDecoder.decodeObject(forKey: "userType") as? String) ?? ""
        self.aboutMe = (aDecoder.decodeObject(forKey: "aboutMe") as? String) ?? ""
        self.intersets = (aDecoder.decodeObject(forKey: "intersets") as? Array) ?? [""]
        self.profession = (aDecoder.decodeObject(forKey: "profession") as?String) ?? ""
        self.socialId = (aDecoder.decodeObject(forKey: "socialId") as?String) ?? ""
        self.isPhoneVerify = aDecoder.decodeBool(forKey: "isPhone")
        self.isNotify = aDecoder.decodeBool(forKey: "isNotify")
        
        self.gender = (aDecoder.decodeObject(forKey: "gender") as? String) ?? ""
        self.bio = (aDecoder.decodeObject(forKey: "bio") as? String) ?? ""
        self.zip = (aDecoder.decodeObject(forKey: "zip") as? String) ?? ""
        self.phone = (aDecoder.decodeObject(forKey: "phone") as? String) ?? ""
        self.address = (aDecoder.decodeObject(forKey: "address") as? String) ?? ""
        self.city = (aDecoder.decodeObject(forKey: "city") as? String) ?? ""
        self.country = (aDecoder.decodeObject(forKey: "country") as? String) ?? ""
        self.state = (aDecoder.decodeObject(forKey: "state") as? String) ?? ""
        //        self.password = (aDecoder.decodeObject(forKey: "password") as? String) ?? ""
        
    }
    
    required init?(map: Map) {
        //super.init(map: Map)
        fatalError("init(map:) has not been implemented")
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(firstName, forKey: "fname")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(lastName, forKey: "lname")
        aCoder.encode(profileImage, forKey: "profileImage")
        aCoder.encode(aboutMe, forKey: "aboutMe")
        aCoder.encode(intersets, forKey: "intersets")
        aCoder.encode(profession, forKey: "profession")
        aCoder.encode(userType, forKey: "userType")
        aCoder.encode(socialId, forKey: "socialId")
        aCoder.encode(isPhoneVerify, forKey: "isPhone")
        aCoder.encode(isNotify, forKey: "isNotify")
        
        // aCoder.encode(password, forKey: "password")
        
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(bio, forKey: "bio")
        aCoder.encode(zip, forKey: "zip")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(country, forKey: "country")
    }
    
    func getFullName() -> String {
        return firstName + " " + lastName
    }
    
}

class LoginResponseData: BaseData{
    var profile = LoginData()
    // var addressess: [AddressData] = []
    var token = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        profile <- map["profile"]
        //   addressess <- map["addressess"]
        token <- map["token"]
    }
}



class LocalData: BaseData {
    
    var profile: ProfileData?
    
    var userName = ""
    var profileData = UserProfileData()
    var socialLogin = false
    var userPostData:[UserPostData] = []
    var usersList = [UserProfileData]()
    var isLogged = false
    var isFirstFbLogin = true
    var fireUserId  =  ""
    var snapshot = 0
    var likeCount = 0
    var postId = ""
    var postAuthorId = ""
    var userWrapperData = [UserWrapperData]()
    var currentUserLikedThePost = false
    var currentUserImg: UIImage!
    var userActivityData = UserActivityData()
   
    override func mapping(map: Map) {
        
        profile <- map["profile"]
        socialLogin <- map["socialLogin"]

        userPostData <- map["userPostData"]
        userName <- map["userName"]
        
        profileData <- map["profiledata"]

        usersList <- map["UserProfileData"]
        isLogged <- map["isLogged"]
        fireUserId <- map["fireUserId"]
        snapshot <- map["snapshot"]
        userWrapperData <- map["userWrapperData"]
        isFirstFbLogin <- map["isFirstFbLogin"]
        postId <- map["postId"]
        postAuthorId <- map["postAuthorId"]

        likeCount <- map["likeCount"]
        currentUserLikedThePost <- map["currentUserLikedThePost"]
        currentUserImg <- map["currentUserImg"]
        userActivityData <- map["userActivityData"]
    }
    
}
//
class ProfileDataList: BaseData {
    
    var profile:[UserPostData] = []
    
    override func mapping(map: Map) {
        profile <- map["profile"]
        
    }
    
}




// 2) User Login Api

class LoginData: BaseData {
    
    var user_id = ""
    var userName = ""
    var user_full_name = ""
    var user_email = ""
    var user_phone = ""
    var userType = ""
    var user_image = ""
    var gender = ""
    var token = ""
    var password = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        user_id <- map["userId"]
        userName <- map["userName"]
        user_full_name <- map["name"]
        user_email <- map["email"]
        user_phone <- map["phoneNo"]
        userType <- map["userType"]
        user_image <- map["imgUrl"]
        gender <- map["gender"]
        token <- map["token"]
        password <- map["password"]
        
        
    }
}

class UserRootdata: BaseData{
    var userId = ""
    var userWrapperData = UserWrapperData()
    
    override func mapping(map: Map) {
        userId <- map["userId"]
        userWrapperData <- map["userWrapperData"]
        
    }
    
}

class UserWrapperData:BaseData{
    
    var activity: [String: UserActivityData] = [:]
    var profile = UserProfileData()
    
    
    override func mapping(map: Map) {
        activity <- map["activity"]
        profile <- map["profile"]
        
        
    }
}

class UserActivityData: BaseData{
    
    var caption = ""
    var image = ""
    var likeCount = [String:Any]()
    var postID = ""
    var peopleWhoLike = [String]()
    var authorName = ""
    var authorID = ""
    var likes = 0
    var currentUserLikedThePost = false
    var userProfilePic = ""
    var postTime = NSDate().timeIntervalSince1970

    override func mapping(map: Map) {
        caption <- map["caption"]
        image <- map["image"]
        likeCount <- map["likeCount"]
        postID <- map["postID"]
        peopleWhoLike <- map["peopleWhoLike"]
        authorName <- map["authorName"]
        authorID <- map["authorID"]
        likes <- map["likes"]
        currentUserLikedThePost <- map["currentUserLikedThePost"]
        userProfilePic <- map["userProfilePic"]
        postTime <- map["postTime"]
    }
}

class UserProfileData:BaseData{
    
    var email = ""
    var password = ""
    var username = ""
    var fullname = ""
    
    var profilepic = ""
    var userGender = ""
    var userPhoneNumber = ""
    var userBio = ""
    var fbforfirsttime = true
    var ifUsernameEmpty = true
    override func mapping(map: Map) {
        email <- map["email"]
        password <- map["password"]
        username <- map["username"]
        profilepic <- map["profilepic"]
        userGender <- map["userGender"]
        userPhoneNumber <- map["userPhoneNumber"]
        userBio <- map["userBio"]
        fullname <- map["fullname"]
        fbforfirsttime <- map["fbforfirsttime"]
        ifUsernameEmpty <- map["ifUsernameEmpty"]


    }
}

// For comment

class CommentData:BaseData{
    var currentUserId = ""
    var commentuserName = ""
    var commentUserimg = ""
    override func mapping(map: Map) {
        
        currentUserId <- map["comment"]
        commentuserName <- map["commentAuthorName"]
        commentUserimg <- map["commentUserimg"]

    }
}

// For comment

class LikePostData:BaseData{
    var authorNameWhoLike = ""
    var authorid = ""
    override func mapping(map: Map) {
        
        authorNameWhoLike <- map["authorNameWhoLike"]
        authorid <- map["authorid"]
    }
}



