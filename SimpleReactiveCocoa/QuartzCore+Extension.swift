//
//  QuartzCore+Extension.swift
//  SimpleReactiveCocoa
//
//  Created by Michael on 22/5/2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import QuartzCore

extension CALayer {
    
    func setCornerRadius(to radius: CGFloat, maskToBounds mask: Bool) {
        
        cornerRadius = radius
        masksToBounds = mask
        
    }
    
}
