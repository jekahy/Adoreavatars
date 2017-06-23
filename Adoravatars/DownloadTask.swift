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
}


class DownloadTask{
    
    let taskID:Int
    let avatar:Avatar
    
    private (set) var updatedAt = Date()
    
    private let eventsSubj = PublishSubject<DownloadTaskEvent>()
    private (set) lazy var events:Observable<DownloadTaskEvent> = self.eventsSubj.asObservable()
    
    private let disposeBag = DisposeBag()
        
    init(taskID:Int, avatar:Avatar, sessionObservable:Observable<SessionDownloadEvent>, cache:URLCache) {
        
        self.taskID = taskID
        self.avatar = avatar

        eventsSubj.asObservable().subscribe { [unowned self] event in
            self.updatedAt = Date()
        }.disposed(by: disposeBag)
        
     
        sessionObservable.subscribe(onNext: {[unowned self] sessionEvent in
            
           self.handleSessionEvent(sessionEvent, cache: cache)
            
        }).disposed(by: disposeBag)
    }
    
    private func handleSessionEvent(_ sessionEvent:SessionDownloadEvent, cache:URLCache)
    {
        switch sessionEvent.type {
            
        case .didWriteData(let progress):
            
            self.eventsSubj.onNext(.progress(progress))
            
        case .didFinishDownloading(let location):
            
            guard let data = try? Data(contentsOf: location), let image = UIImage(data: data) else
            {
                self.eventsSubj.onError(DownloadError.failed)
                return
            }
            
            self.cacheData(data, for: sessionEvent.task, cache: cache)
            
            self.eventsSubj.onNext(.done(image))
            self.eventsSubj.onCompleted()
            
        case .didCompleteWithError( let error):
            
            if let error = error {
                self.eventsSubj.onError(error)
            }
        }
    }
}

extension DownloadTask {
    
    fileprivate func cacheData(_ data:Data, for task:URLSessionTask, cache:URLCache)
    {
        if let response = task.response, let request = task.originalRequest{
            let cached = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cached, for: request)
        }
    }
}
