//
//  AvatarsManager.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum DownloadState:String {
    case queued = "queued"
    case inProgress = "in progress"
    case done = "done"
    case failed = "failed"
}

enum DownloadError:Error {
    
    case failed
}


class AvatarsManager:NSObject{
    
    static let shared = AvatarsManager()
    private let baseUrl = "http://api.adorable.io/avatar/"
    
    private lazy var session:URLSession = {
        let mb = 1024*1024
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = URLCache(memoryCapacity: 100*mb, diskCapacity: 100*mb, diskPath: "avatars")
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    fileprivate let downloadsVar = Variable<[DownloadTask]>([])
    private (set) lazy var downloadTasks:Observable<[DownloadTask]> = self.downloadsVar.asObservable()
    
    
    func downloadAvatarImage(_ avatar:Avatar)->Observable<UIImage?>
    {
        let task = getAvatar(avatar.identifier)
        return task.completionSubj.asObservable()
    }
    
    
    func getAvatars(_ avatarIdentifiers:[String])->[Avatar]
    {
        return avatarIdentifiers.map{getAvatar($0).avatar}
    }
    
    func getAvatar(_ avatartID:String)->DownloadTask
    {
        
        if let task = downloadsVar.value.first(where: {$0.avatar.identifier == avatartID}){
            return task
        }

        let avatar = Avatar(identifier: avatartID)
        let url = urlForAvatarID(avatar.identifier)
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        let sessionTask = session.downloadTask(with: request)
        sessionTask.resume()

        let downloadTask = DownloadTask(taskID: sessionTask.taskIdentifier, avatar: avatar)
        downloadsVar.value.append(downloadTask)
        return downloadTask
    }
    
    
    private func urlForAvatarID(_ id:String)->URL
    {
        var path = baseUrl + id
        path = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        return URL(string:path)!
    }
}


extension AvatarsManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        guard let dTask = retrieveTaskWithID(downloadTask.taskIdentifier) else {
            return
        }
        
        dTask.progressSubj.onCompleted()

        if let data = try? Data(contentsOf: location), let image = UIImage(data: data)
        {
            dTask.state = .done
            dTask.completionSubj.onNext(image)
            
        }else{
            dTask.state = .failed
            dTask.completionSubj.onError(DownloadError.failed)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard let dTask = retrieveTaskWithID(downloadTask.taskIdentifier) else {
            return
        }
        
        let progress = Double(totalBytesWritten/totalBytesExpectedToWrite)
        dTask.state = .inProgress
        dTask.progressSubj.onNext(progress)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
     
        guard let dTask = retrieveTaskWithID(task.taskIdentifier) else {
            return
        }
        
        if let error = error {
            dTask.state = .failed
            dTask.completionSubj.onError(error)
        }
    }
    
    
    private func retrieveTaskWithID(_ taskID:Int)->DownloadTask?
    {
        return downloadsVar.value.first(where: {$0.taskID == taskID})
    }

}

