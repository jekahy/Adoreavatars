//
//  DownloadTask.swift
//  Adoravatars
//
//  Created by Eugene on 12.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift

protocol DownloadTaskType {
    
    var fileName:String{get}

    var progress:Observable<Double>{get}
    var status:Observable<DownloadTask.Status>{get}
    var updatedAt:Observable<Date>{get}
    var data:Observable<Data?>{get}
}

class DownloadTask:DownloadTaskType {
    
    enum Status:String {
        case queued = "queued"
        case inProgress = "in progress"
        case done = "done"
        case failed = "failed"
    }

    let fileName:String
    
    private let progressSubj = BehaviorSubject<Double>(value: 0)
    private (set) lazy var progress:Observable<Double> = self.progressSubj.asObservable().distinctUntilChanged()
    private let statusSubj = BehaviorSubject<Status>(value: .queued)
    private (set) lazy var status:Observable<Status> = self.statusSubj.asObservable()
    private let updatedAtSubj = BehaviorSubject<Date>(value: Date())
    private (set) lazy var updatedAt:Observable<Date> = self.updatedAtSubj.asObservable()
    private let dataSubj = BehaviorSubject<Data?>(value:nil)
    private (set) lazy var data:Observable<Data?> = self.dataSubj.asObservable().shareReplay(1)

    private let disposeBag = DisposeBag()


    init(_ fileName:String, eventsObservable:Observable<DownloadTaskEvent>) {
        
        self.fileName = fileName
        
        eventsObservable.subscribe(onNext: { [weak self] downoadEvent in
            
            self?.updatedAtSubj.onNext(Date())
            switch downoadEvent{
            case .progress(let progress):
                self?.statusSubj.onNext(.inProgress)
                self?.progressSubj.onNext(progress)
                
            case .done(let data):
                self?.dataSubj.onNext(data)
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
