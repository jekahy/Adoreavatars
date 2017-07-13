//
//  APIService.swift
//  Adoravatars
//
//  Created by Eugene on 11.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation
import RxSwift

struct APIBaseURLs {
    
    static let avatar = URL(string:"http://api.adorable.io/avatar")!
}

enum DownloadError:Error {
    case failed
}

protocol APIDownloadable:class {
    
    var baseURL:URL{get}
    var sessionConfig:URLSessionConfiguration{get}
    var cache:URLCache{get}
    var downloadTasks:Observable<[DownloadTaskType]>{get}

    func downloadFileWithProgress(fileURL:URL, fileName:String)->DownloadTaskType
}

class APIService:APIDownloadable {
    
    let baseURL:URL
    let sessionConfig:URLSessionConfiguration
    let cache:URLCache
    
    private (set) lazy var session:URLSession = {
        
        let config = self.sessionConfig
        config.urlCache = self.cache
        return URLSession(configuration: config, delegate: self.sessionDelegateObserver, delegateQueue: nil)
    }()

    
    fileprivate let downloadsVar = Variable<[DownloadTaskType]>([])
    private (set) lazy var downloadTasks:Observable<[DownloadTaskType]> = self.downloadsVar.asObservable()
    
    fileprivate let sessionDelegateObserver = URLSessionDownloadEventsObserver()
    fileprivate lazy var sessionEventsObservable: Observable<SessionDownloadEvent> = self.sessionDelegateObserver.sessionEvents
    
    init(baseURL:URL, sessionConfiguration:URLSessionConfiguration=APIService.defaultSessionConfiguration, cache:URLCache=APIService.defaultCache)
    {
        self.baseURL = baseURL
        self.sessionConfig = sessionConfiguration
        self.cache = cache
    }
    
    func downloadFileWithProgress(fileURL:URL, fileName:String)->DownloadTaskType
    {
        if let task = self.downloadsVar.value.first(where: {$0.fileName == fileName}){
            return task
        }
        
        let taskEventsObservable = Observable.just(fileURL)
            .map{URLRequest(url: $0, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 10)}
            .map({[weak self] request -> URLSessionDownloadTask? in
                guard let strSelf = self else{
                    return nil
                }
                let sessionTask = strSelf.session.downloadTask(with: request)
                sessionTask.resume()
                return sessionTask
            })
            .unwrap()
            .flatMap({[weak self] sessionTask -> Observable<SessionDownloadEvent> in
                
                self?.sessionObservable(for:sessionTask.taskIdentifier) ?? Observable.never()
            })
            .do(onNext: {[weak self] sessionEvent in
                if let strSelf = self, case .didFinishDownloading(let data) = sessionEvent.type{
                    strSelf.cacheData(data, for: sessionEvent.task, cache: strSelf.cache)
                }
            })
            .flatMap({[weak self] sessionEvent -> Observable<DownloadTaskEvent> in
                
                guard let strSelf = self else{
                    return Observable.never()
                }
                return strSelf.handleSessionEvent(sessionEvent)
            })
            .takeWhile({!$0.didComplete()})
        
        
        let downloadTask = DownloadTask(fileName, eventsObservable:taskEventsObservable)
        self.downloadsVar.value.append(downloadTask)
        return downloadTask
    }
    
    fileprivate func sessionObservable(for taskID:Int)->Observable<SessionDownloadEvent>
    {
        return sessionEventsObservable.filter({$0.task.taskIdentifier == taskID})
        
    }

    fileprivate func cacheData(_ data:Data, for task:URLSessionTask, cache:URLCache)
    {
        if let response = task.response, let request = task.originalRequest{
            let cached = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cached, for: request)
        }
    }
    
    fileprivate func handleSessionEvent(_ sessionEvent:SessionDownloadEvent)-> Observable<DownloadTaskEvent>
    {
        return Observable.create { observer -> Disposable in
            
            switch sessionEvent.type {
                
            case .didWriteData(let progress):
                
                observer.onNext(.progress(progress))
                
            case .didFinishDownloading(let data):
                
                observer.onNext(.done(data))
                observer.onNext(.finish)
                
            case .didCompleteWithError( let error):
                
                if let error = error {
                    observer.onError(error)
                }
                observer.onNext(.finish)
            }
            return Disposables.create()
        }
    }

}


extension APIService{
    
    fileprivate static let mb = 1024*1024
    
    fileprivate static let defaultCache = URLCache(memoryCapacity: 100*mb, diskCapacity: 0, diskPath: nil)
    
    fileprivate static var defaultSessionConfiguration:URLSessionConfiguration{
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = APIService.defaultCache
        return config
    }
}
