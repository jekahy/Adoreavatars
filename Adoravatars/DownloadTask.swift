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
    var progress:Observable<Double>{get}
    var updatedAt:Observable<Date>{get}
    var status:Observable<DownloadTask.Status>{get}
    var image:Observable<UIImage?>{get}
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
    private let progressSubj = BehaviorSubject<Double>(value: 0)
    private let imageSubj = BehaviorSubject<UIImage?>(value:nil)
    
    private (set) lazy var updatedAt:Observable<Date> = self.updatedAtSubj.asObservable()
    private (set) lazy var status:Observable<Status> = self.statusSubj.asObservable()
    
    private (set) lazy var progress:Observable<Double> = self.progressSubj.asObservable().distinctUntilChanged()
    private (set) lazy var image:Observable<UIImage?> = self.imageSubj.asObservable()

    private let disposeBag = DisposeBag()
        
    init(avatar:Avatar, eventsObservable:Observable<DownloadTaskEvent>) {
        
        self.avatar = avatar
        
        eventsObservable.subscribe(onNext: { [weak self] downoadEvent in
            
                self?.updatedAtSubj.onNext(Date())
                switch downoadEvent{
                    case .progress(let progress):
                        self?.statusSubj.onNext(.inProgress)
                        self?.progressSubj.onNext(progress)
                    
                    case .done(let image):
                        self?.imageSubj.onNext(image)
                        self?.statusSubj.onNext(.done)
                        self?.progressSubj.onNext(1)
                    
                    default: break
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

