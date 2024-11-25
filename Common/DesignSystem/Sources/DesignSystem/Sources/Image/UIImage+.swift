//
//  File.swift
//  
//
//  Created by 고영민 on 11/25/24.
//

import UIKit

public extension UIImage {
    enum Icon {
        public static let feed              = UIImage(name: "ic_feed")
        public static let mypage            = UIImage(name: "ic_mypage")
        public static let upload_photo      = UIImage(name: "upload_photo")
        public static let next              = UIImage(name: "ic_next")
        public static let link              = UIImage(name: "ic_link")
        public static let apple             = UIImage(name: "ic_apple")
        public static let kakao             = UIImage(name: "ic_kakao")
        public static let info              = UIImage(name: "ic_info")
        public static let pen               = UIImage(name: "ic_pen")
        public static let success           = UIImage(name: "ic_success")
        public static let fail              = UIImage(name: "ic_fail")
        public static let alarm_default     = UIImage(name: "ic_alarm_default")
        public static let alarm_variant     = UIImage(name: "ic_alarm_variant")
    }
 
    enum Sample {
        public static let sample1 = UIImage(name: "sample")
    }
    
    enum Btn {
        public static let close     = UIImage(name: "btn_close")
        public static let back      = UIImage(name: "btn_back")
        public static let floating  = UIImage(name: "btn_floating")
        public static let more  = UIImage(name: "btn_more")
        public static let setting  = UIImage(name: "btn_setting")
    }
}

extension UIImage {
    convenience init?(name: String) {
        self.init(named: name, in: .module, with: nil)
    }
}

extension UIImage {
   public func resizing(width: CGFloat, height: CGFloat) -> UIImage {
       let size = CGSize(width: width, height: height)
       let render = UIGraphicsImageRenderer(size: size)
       let renderImage = render.image { context in
           self.draw(in: CGRect(origin: .zero, size: size))
       }
       return renderImage
   }
    
    public func resizeWithWidth(width: CGFloat) -> UIImage? {
         let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
         imageView.contentMode = .scaleAspectFit
         imageView.image = self
         UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
         guard let context = UIGraphicsGetCurrentContext() else { return nil }
         imageView.layer.render(in: context)
         guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
         UIGraphicsEndImageContext()
         return result
     }
}
