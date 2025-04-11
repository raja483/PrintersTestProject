//
//  Item.swift
//  RSPrinter
//
//  Created by Rajasekhar on 10/04/25.
//

import Foundation
import SwiftData

@Model
final class Printer {
    
    var url: String
    var name: String
    var location: String
    
    init(url: String, name: String, location: String) {
        self.url = url
        self.name = name
        self.location = location
    }
}
