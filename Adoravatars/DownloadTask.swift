//
//  DownloadTask.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift

enum DownloadTaskEvent:CustomStringConvertible {

    case progress(Double)
    case done(UIImage)
    case finish
    
    func didComplete()->Bool {
        switch self {
        case .finish: return true
        default:      return false
        }
    }
    
    var description: String {
        
        switch self {
        case .progress: return "in progress"
        default:        return "done"
        }
    }
}


class DownloadTask {
    
    let avatar:Avatar
    let events:Observable<DownloadTaskEvent>
    private (set) var updatedAt = Date()

    private let disposeBag = DisposeBag()
        
    init(avatar:Avatar, eventsObservable:Observable<DownloadTaskEvent>) {
        
        self.avatar = avatar
        self.events = eventsObservable
        events.subscribe { [weak self] _ in
            self?.updatedAt = Date()
        }.disposed(by: disposeBag)
    }
}
