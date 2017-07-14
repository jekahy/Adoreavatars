//
//  UIStoryboardExtensions.swift
//  Adoravatars
//
//  Created by Eugene on 14.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T>(ofType type: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: type)) as! T
    }
}
