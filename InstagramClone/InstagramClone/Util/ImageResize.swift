//
//  ImageResize.swift
//  InstagramClone
//
//  Created by Jaspinder Singh on 18/03/22.
//  Copyright © 2020 Jaspinder Singh. All rights reserved.
//

import Foundation
import UIKit

class ImageEdit {
    static let instance = ImageEdit()

    func resizeAndCompressImageWith(image: UIImage, maxWidth: CGFloat, maxHeight: CGFloat, compressionQuality: CGFloat) -> Data? {

        let horizontalRatio = maxWidth / image.size.width
        let verticalRatio = maxHeight / image.size.height


        let ratio = min(horizontalRatio, verticalRatio)
        print("Image Ratio: \(ratio)")

        let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        print("NewSize: \(String(describing: newSize))")
        var newImage: UIImage

        if #available(iOS 10.0, *) {
            print("UIGraphicsImageRendererFormat")
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = false
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            }
        } else {
            print("UIGraphicsBeginImageContextWithOptions")
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        print("NewImageSize: width: \(newImage.size.width) height: \(newImage.size.height)")

        let png = newImage.pngData()
        let pngImg = UIImage.init(data: png!)!
        print("PNG - width: \(pngImg.size.width) - height: \(pngImg.size.height)")

        let data = newImage.jpegData(compressionQuality: compressionQuality)
        let jpgImg = UIImage.init(data: data!)!
        print("JPG - width: \(jpgImg.size.width) - height: \(jpgImg.size.height)")

        let fullData = newImage.jpegData(compressionQuality: 1.0)
        let jpgFull = UIImage.init(data: fullData!)!
        print("JPG FULL - width: \(jpgFull.size.width) - height: \(jpgFull.size.height)")

        return data

    }
}
