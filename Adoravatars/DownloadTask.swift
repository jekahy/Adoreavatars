//
//  DownloadTask.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift



protocol DownloadTaskType {
    
    var avatar:Avatar{get}
    var events:Observable<DownloadTaskEvent>{get}
    var updatedAt:Observable<Date>{get}
    var status:Observable<DownloadTask.Status>{get}
}


class DownloadTask:DownloadTaskType {
    
    enum Status:String {
        case queued = "queued"
        case inProgress = "in progress"
        case done = "done"
        case failed = "failed"
    }
    
    let avatar:Avatar
    private let updatedAtSubj = BehaviorSubject<Date>(value: Date())
    private let statusSubj = BehaviorSubject<Status>(value: .queued)
    
    
    private (set) var events:Observable<DownloadTaskEvent>
    private (set) lazy var updatedAt:Observable<Date> = self.updatedAtSubj.asObservable()
    private (set) lazy var status:Observable<Status> = self.statusSubj.asObservable()

    private let disposeBag = DisposeBag()
        
    init(avatar:Avatar, eventsObservable:Observable<DownloadTaskEvent>) {
        
        self.avatar = avatar
        self.events = eventsObservable
        
        events.subscribe(onNext: { [weak self] downoadEvent in
            
                self?.updatedAtSubj.onNext(Date())
                switch downoadEvent{
                    case .progress: self?.statusSubj.onNext(.inProgress)
                    default:        self?.statusSubj.onNext(.done)
                }

            }, onError: {[weak self] error in
                self?.updatedAtSubj.onNext(Date())
                self?.statusSubj.onNext(.failed)
            
            }, onCompleted: {  [weak self] in
                self?.statusSubj.onNext(.done)
            
        }).disposed(by: disposeBag)
    }
}


extension DownloadTask:Equatable {
    
    
    static func ==(lhs: DownloadTask, rhs: DownloadTask) -> Bool
    {
        return lhs.avatar == rhs.avatar
    }
}

