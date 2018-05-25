//
//  LoginResultViewController.swift
//  SimpleReactiveCocoa
//
//  Created by Michael on 22/5/2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import UIKit

import ReactiveCocoa
import ReactiveSwift
import Result

class LoginResultViewController: UIViewController {

    var tapGesture = UITapGestureRecognizer()
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    fileprivate func setupViews() {
        
        title = "Login Result"
        
        tapGesture.reactive.stateChanged.observeResult { (result) in
            
            guard let tapGesture = result.value else {
                return
            }
            
            if tapGesture.state == .ended {
                
                tapGesture.isEnabled = false
                
                UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                    
                    self.label.transform = CGAffineTransform(scaleX: 2, y: 2)
                    
                }, completion: { (success) in
                    
                    self.label.transform = CGAffineTransform.identity
                    
                    tapGesture.isEnabled = true
                    
                })
                
            }
            
        }
        
        view.addGestureRecognizer(tapGesture)
        
    }

}
