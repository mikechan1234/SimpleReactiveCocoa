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
    
    fileprivate var disposable = CompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupViews()
        
    }
    
    fileprivate func setupViews() {
        
        title = "Reactive Cocoa Log In"
        
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        loginButton.isEnabled = false
        loginButton.setBackgroundImage(UIImage.makeImage(from: UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)), for: .normal)
        loginButton.layer.setCornerRadius(to: 5, maskToBounds: true)
        
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
        
        loginButton.reactive.isEnabled <~ Signal.combineLatest(usernameTextField.reactive.textValues, passwordTextField.reactive.textValues).map({ (value) -> Bool in
            
            guard let usernameText = value.0, let passwordText = value.1 else {
                return false
            }
            
            return usernameText.count > 6 && passwordText.count > 4
            
        })
        
        disposable += loginButton.reactive.controlEvents(.touchUpInside).observeResult {[weak self] (result) in
            
            self?.performSegue(withIdentifier: "toLoginResult", sender: nil)
            
        }
        
    }

}

