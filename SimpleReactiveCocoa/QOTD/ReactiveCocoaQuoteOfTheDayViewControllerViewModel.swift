//
//  ReactiveCocoaQuoteOfTheDayViewControllerViewModel.swift
//  SimpleReactiveCocoa
//
//  Created by Michael on 23/5/2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import ReactiveSwift
import Result

struct ReactiveCocoaQuoteOfTheDayViewControllerViewModel {
    
    func getQuote() -> SignalProducer<(String, String), NSError> {
        
        return downloadQuote().flatMap(FlattenStrategy.merge) { (data) -> SignalProducer<Quote, NSError> in

            return self.parseResponse(data)

        }.flatMap(FlattenStrategy.merge, { (quote) -> SignalProducer<(String, String), NSError> in
            
            return self.retrieveContentFrom(quote)
            
        })
    
    }
    
    fileprivate func downloadQuote() -> SignalProducer<Data, NSError> {
        
        return SignalProducer<Data, NSError> { (observer, lifetime) in
            
            guard let url = URL(string: "http://quotesondesign.com/wp-json/posts?filter[orderby]=rand&filter[posts_per_page]=1") else {
                observer.send(error: NSError(domain: "SimpleReactiveCocoaAPIError", code: 0, userInfo: nil))
                observer.sendCompleted()
                return
            }
            
            do {
                
                let data = try Data(contentsOf: url)
                observer.send(value: data)
                
            } catch let error {
            
                observer.send(error: error as NSError)
            
            }
            
            observer.sendCompleted()
            
        }
        
    }
    
    fileprivate func parseResponse(_ data: Data) -> SignalProducer<Quote, NSError> {
        
        return SignalProducer<Quote, NSError> { (observer, lifetime) in
            
            do {
                
                let quotes = try JSONDecoder().decode([Quote].self, from: data)
                
                if let quote = quotes.first {
                    
                    observer.send(value: quote)

                } else {
                    
                    observer.send(error: NSError(domain: "SimpleReactiveCocoaAPIError", code: 1, userInfo: nil))

                }
                
            } catch let error {
                
                observer.send(error: error as NSError)
                
            }
            
            observer.sendCompleted()
            
        }
        
    }
    
    fileprivate func retrieveContentFrom(_ quote: Quote) -> SignalProducer<(String, String), NSError> {
        
        return SignalProducer<(String, String), NSError>({ (observer, lifetime) in
            
            guard let data = quote.content.data(using: .utf8) else {
                
                observer.send(error: NSError(domain: "SimpleReactiveCocoaAPIError", code: 1, userInfo: nil))
                observer.sendCompleted()
                return
                
            }
            
            let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
            
            do {
                
                let attributedString = try NSAttributedString(data: data, options: attributedOptions, documentAttributes: nil)
                
                observer.send(value: (attributedString.string, quote.title))
                
            } catch {
                
                observer.send(error: NSError(domain: "SimpleReactiveCocoaAPIError", code: 1, userInfo: nil))
                
            }
            
            observer.sendCompleted()
            
        })
        
    }
    
}
