//
//  LoginViewController.swift
//  SimpleReactiveCocoa
//
//  Created by Michael on 22/5/2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViews()
        
    }

    fileprivate func setupViews() {
        
        title = "Normal Log In"
        
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.isEnabled = false
        loginButton.setBackgroundImage(UIImage.makeImage(from: UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)), for: .normal)
        loginButton.layer.setCornerRadius(to: 5, maskToBounds: true)
        
    }
    
}


// MARK: - IBAction

extension LoginViewController {
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        performSegue(withIdentifier: "toLoginResult", sender: nil)
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var textFieldText = textField.text else {
            return true
        }
        
        textFieldText = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        
        if textField == usernameTextField {
            
            loginButton.isEnabled = validateUsername(textFieldText) && validPassword(passwordTextField.text ?? "")
            
        } else if textField == passwordTextField {
            
            loginButton.isEnabled = validateUsername(usernameTextField.text ?? "") && validPassword(textFieldText)
            
        }
        
        return true
        
    }
    
}

extension LoginViewController {
    
    func validateUsername(_ text: String) -> Bool {
        
        return text.count > 6
        
    }
    
    func validPassword(_ text: String) -> Bool {
        
        return text.count > 4
        
    }
    
}
