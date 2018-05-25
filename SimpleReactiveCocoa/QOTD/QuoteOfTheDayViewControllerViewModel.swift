//
//  QuoteOfTheDayViewControllerViewModel.swift
//  SimpleReactiveCocoa
//
//  Created by Michael on 23/5/2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import ReactiveSwift
import Result

struct QuoteOfTheDayViewControllerViewModel {
    
    func getQuote(completionHandler: (((String, String)?, Error?) -> ())? = nil) {
     
        guard let url = URL(string: "http://quotesondesign.com/wp-json/posts?filter[orderby]=rand&filter[posts_per_page]=1") else {
            
            completionHandler?(nil, NSError(domain: "SimpleReactiveCocoaAPIError", code: 0, userInfo: nil))
            return
            
        }
        
        DispatchQueue.global().async {
            
            do {
                
                let data = try Data(contentsOf: url)
                
                self.parseResponse(data, completionHandler: completionHandler)
                
            } catch let error {
                
                completionHandler?(nil, error)
                
            }
            
        }
        
    }
    
    fileprivate func parseResponse(_ data: Data, completionHandler:(((String, String)?, Error?) -> ())? = nil) {
        
        do {
            
            let quotes = try JSONDecoder().decode([Quote].self, from: data)
            
            if let quote = quotes.first {
                
                retrieveContentFrom(quote, completionHandler: completionHandler)
                
            } else {
                
                completionHandler?(nil, NSError(domain: "SimpleReactiveCocoaAPIError", code: 1, userInfo: nil))
                
            }
            
        } catch let error {
            
            completionHandler?(nil, error)
            
        }
        
    }
    
    fileprivate func retrieveContentFrom(_ quote: Quote, completionHandler: (((String, String)?, Error?) -> ())? = nil) {
        
        guard let data = quote.content.data(using: .utf8) else {
            
            completionHandler?(nil, NSError(domain: "SimpleReactiveCocoaAPIError", code: 1, userInfo: nil))
            return
            
        }
        
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
        
        do {
            
            let attributedString = try NSAttributedString(data: data, options: attributedOptions, documentAttributes: nil)
            
            completionHandler?((attributedString.string, quote.title), nil)
            
        } catch {
            
            completionHandler?(nil, NSError(domain: "SimpleReactiveCocoaAPIError", code: 1, userInfo: nil))
            
        }
        
    }
    
    
}
