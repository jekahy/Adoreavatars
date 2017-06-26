//
//  DownloadTask.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift

enum DownloadTaskEvent {

    case progress(Double)
    case done(UIImage)
    case finish
    
    func didComplete()->Bool {
        switch self {
        case .finish: return true
        default:      return false
        }
    }
}


class DownloadTask {
    
    enum DownloadTaskStatus:String {
        case queued = "queued"
        case inProgress = "in progress"
        case done = "done"
        case failed = "failed"
    }
    
    let avatar:Avatar
    private (set) var events:Observable<DownloadTaskEvent>
    private (set) var updatedAt = Date()
    private (set) var status = DownloadTaskStatus.queued

    private let disposeBag = DisposeBag()
        
    init(avatar:Avatar, eventsObservable:Observable<DownloadTaskEvent>) {
        
        self.avatar = avatar
        self.events = eventsObservable
        self.events = eventsObservable.do(onNext: { [weak self] downoadEvent in
            self?.updatedAt = Date()
            switch downoadEvent{
                case .progress: self?.status = .inProgress
                default:        self?.status = .done
            }
            
        }, onError: { [weak self] _ in
            self?.updatedAt = Date()
            self?.status = .failed
        }, onCompleted: { [weak self] in
            self?.status = .done
        })
        
    }
}
