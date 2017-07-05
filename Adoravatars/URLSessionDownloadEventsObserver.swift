//
//  URLSessionDownloadEventsObserverType.swift
//  Adoravatars
//
//  Created by Eugene on 23.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation
import RxSwift


protocol URLSessionDownloadEventsObserverType {

    var sessionEvents: Observable<SessionDownloadEvent> { get }
}


final class URLSessionDownloadEventsObserver : NSObject {
    
    let eventsSubject = PublishSubject<SessionDownloadEvent>()
}


extension URLSessionDownloadEventsObserver : URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        do{
            let data = try Data(contentsOf: location)
            let type = SessionDownloadEventType.didFinishDownloading(data: data)
            let event = SessionDownloadEvent(type: type, session: session, task: downloadTask)
            eventsSubject.onNext(event)
        }catch (let error){
            eventsSubject.onError(error)
        }
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Double(totalBytesWritten/totalBytesExpectedToWrite)
        let type:SessionDownloadEventType = .didWriteData(progress: progress)
        let event = SessionDownloadEvent(type: type, session: session, task: downloadTask)
        eventsSubject.onNext(event)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        let type:SessionDownloadEventType = .didCompleteWithError(error: error)
        let event = SessionDownloadEvent(type: type, session: session, task: task)
        eventsSubject.onNext(event)
    }
}

extension URLSessionDownloadEventsObserver : URLSessionDownloadEventsObserverType {
 
    var sessionEvents: Observable<SessionDownloadEvent> {
        return eventsSubject.asObservable()
    }
}
