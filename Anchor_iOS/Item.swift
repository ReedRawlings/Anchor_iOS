//
//  Item.swift
//  Anchor_iOS
//
//  Created by Reed Rawlings on 11/5/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
