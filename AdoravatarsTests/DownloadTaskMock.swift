//
//  DownloadTaskMock.swift
//  Adoravatars
//
//  Created by Eugene on 30.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit
import RxSwift

@testable import Adoravatars

class DownloadTaskMock: DownloadTaskType {
    
    let avatar = defaultAvatar
    let events:Observable<DownloadTaskEvent>
    let updatedAt:Observable<Date>
    
    let status:Observable<DownloadTask.Status>

    static let defaultDate = Date(timeIntervalSince1970: 10000)
    static let defaultImage = UIImage(named:"test_icon")!
    static let defaultAvatar = Avatar(identifier: "Dart")
    static let defaultStatus = DownloadTask.Status.done
    static let defaultDownloadEvents:[DownloadTaskEvent] = [.progress(0.5), .done(defaultImage)]
    
    init(_ status:Observable<DownloadTask.Status> = Observable.just(DownloadTaskMock.defaultStatus),
         updatedAt:Observable<Date> = Observable.just(DownloadTaskMock.defaultDate),
         events:Observable<DownloadTaskEvent> = Observable.from(DownloadTaskMock.defaultDownloadEvents)) {
        
        self.status = status
        self.updatedAt = updatedAt
        self.events = events
    }
}


extension DownloadTaskMock:Equatable
{
    static func ==(lhs: DownloadTaskMock, rhs: DownloadTaskMock) -> Bool
    {
        return lhs === rhs
    }
}
