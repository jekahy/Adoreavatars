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
    
 
    let baseURL = FDP.defaultBaseURL
    let cache = FDP.defaultCache
    let sessionConfig = FDP.defaultSessionConfig
    
    let downloadTasks:Observable<[DownloadTaskType]> = Observable.just([FDP.defaultTask])
    
    func downloadFileWithProgress(fileURL:URL, fileName:String)->DownloadTaskType
    {
        return DownloadTaskMock()
    }
}
