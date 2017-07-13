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
    
    let fileName = defaultAvatar.identifier

    let avatar = defaultAvatar
    let updatedAt:Observable<Date>
    let progress:Observable<Double>
    let status:Observable<DownloadTask.Status>
    let data:Observable<Data?>


    private static let imgPath = Bundle.main.path(forResource: "test_icon", ofType: "png")!
    
    static let defaultDate = Date(timeIntervalSince1970: 10000)
    static let defaultImage = UIImage(data: defaultData)!
    static let defaultData = try! Data(contentsOf: URL(fileURLWithPath: imgPath))
    static let defaultAvatar = Avatar(identifier: "Dart")
    static let defaultStatus = DownloadTask.Status.done
    static let defaultProgress = [0,0.5,1]
    static let defaultDownloadEvents = APIServiceStubbed.defaultDownloadEvents
    
    init(_ status:Observable<DownloadTask.Status> = Observable.just(DownloadTaskMock.defaultStatus),
         updatedAt:Observable<Date> = Observable.just(DownloadTaskMock.defaultDate),
         progress:Observable<Double> = Observable.from(DownloadTaskMock.defaultProgress),
         data:Observable<Data?> = Observable.just(DownloadTaskMock.defaultData)) {
        
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
