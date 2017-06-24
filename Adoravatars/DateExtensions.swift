//
//  DateExtensions.swift
//  Adoravatars
//
//  Created by Eugene on 24.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation

extension Date{
    
    var string:String {
        let df = DateFormatter()
        df.dateFormat = "dd, hh:mm:ss"
        return df.string(from: self)
    }
}
