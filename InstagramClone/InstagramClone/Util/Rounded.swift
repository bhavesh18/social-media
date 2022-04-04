//
//  Rounded.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 06/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import Foundation
import UIKit
extension UIView {

  @IBInspectable var cornerRadius: CGFloat {

   get{
        return layer.cornerRadius
    }
    set {
        layer.cornerRadius = newValue
        layer.masksToBounds = newValue > 0
    }
  }

  @IBInspectable var borderWidth: CGFloat {
    get {
        return layer.borderWidth
    }
    set {
        layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColor: UIColor? {
    get {
        return UIColor(cgColor: layer.borderColor!)
    }
    set {
        layer.borderColor = borderColor?.cgColor
    }
  }
}
