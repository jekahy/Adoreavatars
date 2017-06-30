//
//  DownloadTaskEvent.swift
//  Adoravatars
//
//  Created by Eugene on 29.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift

enum DownloadTaskEvent:Equatable {
    
    case progress(Double)
    case done(UIImage)
    case finish
    
    func didComplete()->Bool {
        switch self {
        case .finish: return true
        default:      return false
        }
    }
    
    static func ==(lhs: DownloadTaskEvent, rhs: DownloadTaskEvent) -> Bool
    {
        guard lhs.didComplete() == rhs.didComplete() else {
            return false
        }
        
        switch (lhs, rhs) {
        case (let .progress(progressL), let .progress(progressR)):
            return progressL == progressR
        case (let .done(imageL), let .done(imageR)):
            return imageL == imageR
        case (.finish, .finish):
            return true
        default:
            return false
        }
    }
}
