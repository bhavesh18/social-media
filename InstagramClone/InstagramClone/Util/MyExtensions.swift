//
//  MyExtensions.swift
//  InstagramClone
//
//  Created by Bhavesh Sharma on 02/04/22.
//  Copyright © 2022 Jaspinder Singh. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func showLoader(activityColor: UIColor = .white) {
        if let v = self.view{
            
            let backgroundView = UIView()
            
            backgroundView.frame = self.view.frame
            let blackTransparentColor: UIColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.26)
            backgroundView.backgroundColor = blackTransparentColor
            backgroundView.tag = 475646
            
            var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.tag = 475647
            activityIndicator.center = backgroundView.center
            activityIndicator.cornerRadius = 8
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = .medium
            activityIndicator.color = activityColor
            activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            backgroundView.addSubview(activityIndicator)
            v.addSubview(backgroundView)
        }
    }
    
    func hideLoader() {
        
        if let indicator = self.view.viewWithTag(475647){
            indicator.removeFromSuperview()
        }
        
        if let bg = self.view.viewWithTag(475646){
            bg.removeFromSuperview()
        }
        
        self.view.isUserInteractionEnabled = true
    }
}

extension UIImageView{
    func load(urlStr: String){
        guard let url = URL(string: urlStr) else {return}
        
        DispatchQueue.global().async { [weak self] in
            guard let ss = self else{return}
            do{
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        ss.image = image
                    }
                }
            }catch{
                
            }
            
        }
    }
}

extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
