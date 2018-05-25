//
//  APIViewController.swift
//  SimpleReactiveCocoa
//
//  Created by Michael on 23/5/2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import UIKit

class QuoteOfTheDayViewController: UIViewController {

    let viewModel = QuoteOfTheDayViewControllerViewModel()
    
    var refreshBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViews()
        
    }
    
    fileprivate func setupViews() {
        
        title = "Quote Of The Day"
        
        let refreshButton = UIButton(type: .system)
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.setTitleColor(.black, for: .normal)
        refreshButton.setTitleColor(.gray, for: .disabled)
        
        refreshBarButtonItem = UIBarButtonItem(customView: refreshButton)
        
        refreshButton.addTarget(self, action: #selector(QuoteOfTheDayViewController.refreshButtonTapped(sender:)), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = refreshBarButtonItem
        
    }

}


// MARK: - UIControl functions
extension QuoteOfTheDayViewController {
    
    @objc func refreshButtonTapped(sender: UIButton) {
        
        self.refreshBarButtonItem.isEnabled = false
        
        self.mainLabel.text = "Loading..."
        self.mainLabel.textAlignment = .center
        
        self.authorLabel.text = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.viewModel.getQuote { (values, error) in
                
                DispatchQueue.main.async {
                    
                    self.refreshBarButtonItem.isEnabled = true
                
                    if let theError = error {
                        
                        self.handleError(theError as NSError)
                        
                    } else if let response = values {
                        
                        self.handleResponse(response)
                        
                    } else {
                        
                        self.mainLabel.text = "Failed"
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

extension QuoteOfTheDayViewController {
    
    func handleResponse(_ response: (quote: String, title: String)) {
        
        
        self.mainLabel.text = response.quote
        self.mainLabel.textAlignment = .left
        
        self.authorLabel.text = response.title
        
    }
    
    func handleError(_ error: NSError) {
        
        mainLabel.text = "Failed"
        
    }
    
}
