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
    var api:AvatarsProvider{get}
    var downloadsVM:DownloadsVMType{get}
}


class AvatarsVM:AvatarsVMType {
    
    let avatars:Driver<[Avatar]>
    let title: Driver<String>
    
    let api:AvatarsProvider
    
    let downloadsVM: DownloadsVMType
    
    
    init(api:AvatarsProvider = AvatarsManager()){
        
        avatars = api.getAvatars().asDriver(onErrorJustReturn:[])
        title = Observable.just("Adoreavatars").asDriver(onErrorJustReturn: "")
        downloadsVM = DownloadsVM(api: api)
        self.api = api
    }
    
}

extension AvatarsVM:Equatable{
    
    static func ==(lhs: AvatarsVM, rhs: AvatarsVM) -> Bool
    {
        return lhs.api === rhs.api
    }
}
