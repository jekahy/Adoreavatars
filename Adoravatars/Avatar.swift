//
//  Avatar.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//
import Foundation

class Avatar:Equatable{
    
    let identifier:String
    
    init(_ id:String) {
        identifier = id
    }
    
    static func ==(lhs: Avatar, rhs: Avatar) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }

    
}
