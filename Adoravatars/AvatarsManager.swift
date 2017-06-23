//
//  AvatarsManager.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation
import RxSwift

enum DownloadError:Error {
    
    case failed
}


class AvatarsManager:NSObject{
    
    static let shared = AvatarsManager()
    private static let mb = 1024*1024
    private let baseUrl = "http://api.adorable.io/avatar/"
    
    fileprivate let cache = URLCache(memoryCapacity: 100*mb, diskCapacity: 0, diskPath: nil)
    
    private lazy var session:URLSession = {
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = self.cache
        return URLSession(configuration: config, delegate: self.sessionDelegateObserver, delegateQueue: nil)
    }()
    
    fileprivate let downloadsVar = Variable<[DownloadTask]>([])
    private (set) lazy var downloadTasks:Observable<[DownloadTask]> = self.downloadsVar.asObservable()
    
    fileprivate let sessionDelegateObserver = URLSessionDownloadEventsObserver()
    
    private let disposeBag = DisposeBag()
    
    private override init()
    {
        super.init()
        
        sessionDelegateObserver.eventsSubject.subscribe(onNext: {[unowned self] sessionEvent in
            
            guard let dTask = self.retrieveTaskWithID(sessionEvent.task.taskIdentifier) else {
                return
            }
            
            switch sessionEvent.type {
                
            case .didWriteData(let progress):
                
                dTask.eventSubj.onNext(.progress(progress))
                
            case .didFinishDownloading(let location):
                
                guard let data = try? Data(contentsOf: location), let image = UIImage(data: data) else
                {
                    dTask.eventSubj.onError(DownloadError.failed)
                    return
                }
                self.cacheData(data, for: sessionEvent.task, cache: self.cache)
                
                dTask.eventSubj.onNext(.done(image))
                dTask.eventSubj.onCompleted()
                
            case .didCompleteWithError( let error):
                
                if let error = error {
                    dTask.eventSubj.onError(error)
                }
            }
            
            
        }).disposed(by: disposeBag)
    }
    
    
    
func downloadAvatarImage(_ avatar:Avatar)->Observable<DownloadTaskEvent>
    {
        let task = getAvatar(avatar.identifier)
        return task.eventSubj.asObservable()
    }
    
    
    func getAvatars(_ avatarIdentifiers:[String])->[Avatar]
    {
        return avatarIdentifiers.map{getAvatar($0).avatar}
    }
    
    func getAvatar(_ avatartID:String)->DownloadTask
    {
        let avatar = Avatar(identifier: avatartID)
        let request = urlRequestFor(avatar)
        
        let sessionTask = session.downloadTask(with: request)
        sessionTask.resume()

        let downloadTask = DownloadTask(taskID: sessionTask.taskIdentifier, avatar: avatar)

        if let idx = downloadsVar.value.index(where: {$0.avatar == avatar}){
            downloadsVar.value[idx] = downloadTask
        }else{
            downloadsVar.value.append(downloadTask)
        }
        
        return downloadTask
    }
    
    
//    MARK: Helpers
    
    private func urlForAvatarID(_ id:String)->URL
    {
        var path = baseUrl + id
        path = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        return URL(string:path)!
    }
    
    private func urlRequestFor(_ avatar:Avatar)->URLRequest
    {
        let url = urlForAvatarID(avatar.identifier)
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
    }
    
    
    private func retrieveTaskWithID(_ taskID:Int)->DownloadTask?
    {
        return downloadsVar.value.first(where: {$0.taskID == taskID})
    }
    
    
    private func cacheData(_ data:Data, for task:URLSessionTask, cache:URLCache)
    {
        if let response = task.response, let request = task.originalRequest{
            let cached = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cached, for: request)
        }
    }

}

