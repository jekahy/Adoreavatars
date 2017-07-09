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

        status = task.status.map{$0.rawValue}.asDriver(onErrorJustReturn: "")
        timestamp = task.updatedAt.map{$0.string}.asDriver(onErrorJustReturn: "")
        progress = task.progress.map{Float($0)}.asDriver(onErrorJustReturn: 0)
    }
}
