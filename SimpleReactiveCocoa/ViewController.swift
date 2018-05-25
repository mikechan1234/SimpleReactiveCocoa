//
//  ViewController.swift
//  SimpleReactiveCocoa
//
//  Created by Michael on 22/5/2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import UIKit

import ReactiveCocoa
import ReactiveSwift
import Result

class ReactiveLoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupViews()
        
    }
    
    fileprivate func setupViews() {
        
        title = "Reactive Cocoa Log In"
        
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        loginButton.layer.cornerRadius = 5
        
        let greaterThanSixSignal = usernameTextField.reactive.continuousTextValues.map { (text) -> Bool in
            
            guard let textValues = text else {
                return false
            }
            
            return textValues.count > 6
            
        }
        
        let greaterThanFourPasswordSignal = passwordTextField.reactive.continuousTextValues.map { (text) -> Bool in
            
            guard let passwordValue = text else {
                return false
            }
            
            return passwordValue.count > 4
            
        }
        
        loginButton.reactive.isEnabled <~ Signal.combineLatest(greaterThanSixSignal, greaterThanFourPasswordSignal).map { (validations) -> Bool in
            
            return validations.0 && validations.1
            
        }
        
    }


}

