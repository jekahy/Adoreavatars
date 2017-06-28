//
//  DownloadVM.swift
//  Adoravatars
//
//  Created by Eugene on 25.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift
import RxCocoa

protocol DownloadVMType {
    
    var title:Driver<String>{get}
    var status:Driver<String>{get}
    var timestamp:Driver<String>{get}
    var progress:Driver<Float>{get}
}


class DownloadVM:DownloadVMType {
    
    let title:Driver<String>
    let status:Driver<String>
    let timestamp:Driver<String>
    let progress:Driver<Float>
    
    private let disposeBag = DisposeBag()
    
    init(_ task:DownloadTaskType) {

        title = Driver.just(task.avatar.identifier)

        status = task.events.map({ downloadEvent -> String in
            return task.status.rawValue
        }).startWith(DownloadTask.DownloadTaskStatus.queued.rawValue).asDriver(onErrorJustReturn: "")
        
        timestamp = task.events.map({ downloadEvent -> String in
            return task.updatedAt.string
        }).startWith(Date().string).asDriver(onErrorJustReturn: "")
        
        progress = task.events.map({ downloadEvent -> Float in
            switch downloadEvent {
            case .progress(let progress):   return Float(progress)
            default:                        return 1
            }
        }).startWith(0).asDriver(onErrorJustReturn: 0)
        
    }
}
