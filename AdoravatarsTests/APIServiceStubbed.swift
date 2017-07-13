//
//  APIServiceStubbed.swift
//  Adoravatars
//
//  Created by Eugene on 13.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift

@testable import Adoravatars

class APIServiceStubbed:APIDownloadable  {
    
 
    let baseURL = APIServiceStubbed.defaultBaseURL
    let cache = APIServiceStubbed.defaultCache
    let sessionConfig = APIServiceStubbed.defaultSessionConfig
    
    let downloadTasks:Observable<[DownloadTaskType]> = Observable.just([APIServiceStubbed.defaultTask])
    
    static let defaultTask = DownloadTaskMock()
    
    static let defaultDownloadEvents:[DownloadTaskEvent] = DownloadTaskMock.defaultProgress.map{DownloadTaskEvent.progress($0)} + [.done(DownloadTaskMock.defaultData)]
    
    static let defaultEventsObservable = Observable.from(APIServiceStubbed.defaultDownloadEvents)

    func downloadFileWithProgress(fileURL:URL, fileName:String)->DownloadTaskType
    {
        return DownloadTaskMock()
    }
}


extension APIServiceStubbed {
    
    static let defaultBaseURL: URL = URL(string: "http://api.adorable.io/avatar")!
    
    static let defaultSessionConfig:URLSessionConfiguration = {
        let s = URLSessionConfiguration.default
        s.urlCache = APIServiceStubbed.defaultCache
        return s
    }()
    
    static let defaultCache = URLCache(memoryCapacity: 100, diskCapacity: 100, diskPath: nil)
    
    
}
