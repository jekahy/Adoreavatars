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
    var events:Observable<DownloadTaskEvent> {
            return Observable.from(DownloadTaskMock.defaultDownloadEvents)
        
    }
    var updatedAt:Observable<Date>{
     
        guard  let updated = definedUpdatedAt else {
            return Observable.just(DownloadTaskMock.defaultDate)
        }
        return updated
    }
    var status:Observable<DownloadTask.Status> {
        
        guard let dStatus = definedStatus else {
            return Observable.just(DownloadTaskMock.defaultStatus)
        }
        return dStatus
    }
    
    static let defaultDate = Date(timeIntervalSince1970: 10000)
    static let defaultImage = UIImage(named:"test_icon")!
    static let defaultAvatar = Avatar(identifier: "Dart")
    static let defaultStatus = DownloadTask.Status.done
    
    static let defaultDownloadEvents:[DownloadTaskEvent] = [.progress(0.5), .done(defaultImage)]

    var definedStatus:Observable<DownloadTask.Status>?
    var definedUpdatedAt:Observable<Date>?
    
    init(_ status:Observable<DownloadTask.Status>?=nil, updatedAt:Observable<Date>?=nil ) {
        definedStatus = status
        definedUpdatedAt = updatedAt
    }
}


extension DownloadTaskMock:Equatable
{
    static func ==(lhs: DownloadTaskMock, rhs: DownloadTaskMock) -> Bool
    {
        return lhs === rhs
    }
}
