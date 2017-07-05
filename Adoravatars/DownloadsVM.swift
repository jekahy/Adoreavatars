//
//  DownloadsVM.swift
//  Adoravatars
//
//  Created by Eugene on 25.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift
import RxCocoa

protocol DownloadsVMType {
    
    var downloadTasks:Driver<[DownloadTaskType]>{get}
}


class DownloadsVM:DownloadsVMType {
    
    let downloadTasks:Driver<[DownloadTaskType]>
    let api:AvatarsProvider
    
    init(api:AvatarsProvider) {
        downloadTasks = api.downloadTasks.asDriver(onErrorJustReturn: [])
        self.api = api
    }
}


extension DownloadsVM:Equatable{
    
    static func ==(lhs: DownloadsVM, rhs: DownloadsVM) -> Bool
    {
        return lhs.api === rhs.api
    }
}
