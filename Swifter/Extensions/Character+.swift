//
//  Character+.swift
//  Swifter
//
//  Created by Alexandr Onischenko on 15.05.2023.
//

import Foundation

extension Character {
    
    /// Characters that cause the next character to be capitalized.
    fileprivate static let removableCharacters: [Character] = [" ", "_", "-"]
    
    /// Returns whether this causes the next character to be capitalized.
    var isRemovable: Bool {
        Character.removableCharacters.contains(self)
    }
}
