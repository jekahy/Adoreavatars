//
//  AvatarsVM.swift
//  Adoravatars
//
//  Created by Eugene on 25.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AvatarsVMType {
    
    var avatars:Driver<[Avatar]> {get}
    var title:Driver<String>{get}
    var api:AvatarsManager{get}
    func downloadsVM()->DownloadsVMType
}


class AvatarsVM:AvatarsVMType {
    
    let avatars:Driver<[Avatar]>
    let title: Driver<String>
    
    private let disposeBag = DisposeBag()
    let api:AvatarsManager
    
    init(api:AvatarsManager = AvatarsManager()){
        
        self.api = api
        avatars = api.getAvatars().asDriver(onErrorJustReturn:[])
        title = Observable.just("Adoreavatars").asDriver(onErrorJustReturn: "")
    }
    
    
    func downloadsVM() -> DownloadsVMType {
        return DownloadsVM(api: api)
    }
}
