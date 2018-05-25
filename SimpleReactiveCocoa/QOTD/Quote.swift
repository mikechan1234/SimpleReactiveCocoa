//
//  Quote.swift
//  SimpleReactiveCocoa
//
//  Created by Michael on 23/5/2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import Foundation

struct Quote: Codable {
    
    var id: Int
    
    var content: String
    
    var link: String
    
    var title: String
    
    enum CodingKeys: String, CodingKey {
        
        case id = "ID"
        case content
        case link
        case title
        
    }
    
}
