//
//  ReactiveCocoaAPIViewController.swift
//  SimpleReactiveCocoa
//
//  Created by Michael on 23/5/2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import UIKit

import ReactiveCocoa
import ReactiveSwift
import Result

class ReactiveCocoaQuoteOfTheDayViewController: UIViewController {

    var viewModel = ReactiveCocoaQuoteOfTheDayViewControllerViewModel()
    
    var refreshBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViews()
        
    }
    
    fileprivate func setupViews() {
        
        title = "Reactive Quote Of The Day"
        
        let refreshButton = UIButton(type: .system)
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.setTitleColor(.black, for: .normal)
        refreshButton.setTitleColor(.gray, for: .disabled)
        
        refreshBarButtonItem = UIBarButtonItem(customView: refreshButton)
        
        refreshButton.reactive.controlEvents(.touchUpInside).flatMap(.merge) {[weak self] (button) -> SignalProducer<Void, NoError> in
            
            return SignalProducer<Void, NoError>({ (observer, lifetime) in
                
                self?.refreshBarButtonItem.isEnabled = false
                
                self?.mainLabel.text = "Loading..."
                self?.mainLabel.textAlignment = .center
                
                self?.authorLabel.text = ""
                
                observer.send(value: ())
                observer.sendCompleted()
                
            }).observe(on: QueueScheduler.main)
            
        }.throttle(3, on: QueueScheduler.main).flatMap(.latest) { (value) -> SignalProducer<(String, String), NSError> in
                
            return self.viewModel.getQuote().flatMapError({[weak self] (error) -> SignalProducer<(String, String), NSError> in
                
                self?.mainLabel.text = "Failed"
                
                self?.refreshBarButtonItem.isEnabled = true

                return SignalProducer.empty
                
            }).observe(on: QueueScheduler.main)
                
        }.observeResult { (result) in
            
            self.refreshBarButtonItem.isEnabled = true
            
            guard let resultValue = result.value else {
                
                self.mainLabel.text = "Failed"
                return
                
            }
            
            self.mainLabel.text = resultValue.0
            self.mainLabel.textAlignment = .left
            
            self.authorLabel.text = resultValue.1
                
        }
        
        navigationItem.rightBarButtonItem = refreshBarButtonItem
        
    }

}
