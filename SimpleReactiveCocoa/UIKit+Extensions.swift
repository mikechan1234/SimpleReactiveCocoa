//
//  UIKit+Extensions.swift
//  SimpleReactiveCocoa
//
//  Created by Michael on 22/5/2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import UIKit

extension UIButton {
    
    
    
}

extension UIImage {
    
    class func makeImage(from color: UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return img
        
    }
    
}
