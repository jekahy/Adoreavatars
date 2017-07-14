//
//  AvatarDownloadTaskMock.swift
//  Adoravatars
//
//  Created by Eugene on 30.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit
import RxSwift

@testable import Adoravatars

class DownloadTaskMock: DownloadTaskType {
    
    let fileName = FDP.defaultAvatar.identifier

    let avatar = FDP.defaultAvatar
    let updatedAt:Observable<Date>
    let progress:Observable<Double>
    let status:Observable<DownloadTask.Status>
    let data:Observable<Data?>    
    
    init(_ status:Observable<DownloadTask.Status> = Observable.just(FDP.defaultStatus),
         updatedAt:Observable<Date> = Observable.just(FDP.defaultDate),
         progress:Observable<Double> = Observable.from(FDP.defaultProgress),
         data:Observable<Data?> = Observable.just(FDP.defaultData)) {
        
        self.status = status
        self.updatedAt = updatedAt
        self.progress = progress
        self.data = data
    }
}


extension DownloadTaskMock:Equatable
{
    static func ==(lhs: DownloadTaskMock, rhs: DownloadTaskMock) -> Bool
    {
        return lhs === rhs
    }
}
