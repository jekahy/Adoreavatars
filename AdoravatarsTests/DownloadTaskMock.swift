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

class AvatarDownloadTaskMock: AvatarDownloadTaskType {
    
    let avatar = defaultAvatar
    let updatedAt:Observable<Date>
    let progress:Observable<Double>
    let status:Observable<AvatarDownloadTask.Status>
    let image:Observable<UIImage?>


    static let defaultDate = Date(timeIntervalSince1970: 10000)
    static let defaultImage = UIImage(named:"test_icon")!
    static let defaultAvatar = Avatar(identifier: "Dart")
    static let defaultStatus = AvatarDownloadTask.Status.done
    static let defaultProgress = [0,0.5,1]
    static let defaultDownloadEvents = AvatarsManagerStubbed.defaultDownloadEvents
    
    init(_ status:Observable<AvatarDownloadTask.Status> = Observable.just(AvatarDownloadTaskMock.defaultStatus),
         updatedAt:Observable<Date> = Observable.just(AvatarDownloadTaskMock.defaultDate),
         progress:Observable<Double> = Observable.from(AvatarDownloadTaskMock.defaultProgress),
         image:Observable<UIImage?> = Observable.just(AvatarDownloadTaskMock.defaultImage)) {
        
        self.status = status
        self.updatedAt = updatedAt
        self.progress = progress
        self.image = image
    }
}


extension AvatarDownloadTaskMock:Equatable
{
    static func ==(lhs: AvatarDownloadTaskMock, rhs: AvatarDownloadTaskMock) -> Bool
    {
        return lhs === rhs
    }
}
