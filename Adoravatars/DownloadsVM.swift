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
    
    var downloadTasks:Driver<[DownloadTask]>{get}
}


class DownloadsVM:DownloadsVMType {
    
    let downloadTasks:Driver<[DownloadTask]>
    let api:AvatarsManager
    
    init(api:AvatarsManager) {
        self.api = api
        downloadTasks = api.downloadTasks.asDriver(onErrorJustReturn: [])
        
    }
}
