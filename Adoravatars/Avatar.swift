//
//  Avatar.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

struct Avatar:Equatable{
    
    let identifier:String
    
    static func ==(lhs: Avatar, rhs: Avatar) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }
}
