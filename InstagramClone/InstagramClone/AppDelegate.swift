//
//  AppDelegate.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 06/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var window: UIWindow? = {
        return UIApplication.shared.windows.first
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        UINavigationBar.appearance().barTintColor =  UIColor(red: 64/255.0, green: 67/255.0, blue: 84/255.0, alpha: 1.0)
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().tintColor = .white
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().isTranslucent = false
        

        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().tintColor = UIColor(red: 228/255.0, green: 35/255.0, blue: 68/255.0, alpha: 1.0)
        UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
       
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 228/255.0, green: 35/255.0, blue: 68/255.0, alpha: 1.0)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        return  true
    }
    
    


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
//        let handled = ApplicationDelegate.shared.application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
//        // Add any custom logic here.
//        return handled
//    }
    
    
    
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return handled
    }
    
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//            let str_URL = url.absoluteString as NSString
//            if str_URL.contains("fb167425411223085"){
//                return ApplicationDelegate.shared.application(
//                        app,
//                        open: (url as URL?)!,
//                        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String,
//                        annotation: options[UIApplication.OpenURLOptionsKey.annotation])
//              }
//
//
//        return ApplicationDelegate.shared.application(
//                    app,
//                    open: (url as URL?)!,
//                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String,
//                    annotation: options[UIApplication.OpenURLOptionsKey.annotation])
//
//            }
//    


}

