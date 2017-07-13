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
    var api:APIDownloadable{get}
    var service:AvatarsGettable{get}
    var downloadsVM:DownloadsVMType{get}
    
    func avatarVM(for avatar:Avatar)->AvatarVM
}


class AvatarsVM:AvatarsVMType {
    
    let avatars:Driver<[Avatar]>
    let title: Driver<String>
    
    let api:APIDownloadable
    let service:AvatarsGettable
    
    let downloadsVM: DownloadsVMType
    
    init(service:AvatarsGettable = AvatarService(), api:APIDownloadable = APIService(baseURL: APIBaseURLStrings.avatar.url!)){
        
        avatars = service.getAvatars().asDriver(onErrorJustReturn:[])
        title = Observable.just("Adoreavatars").asDriver(onErrorJustReturn: "")
        downloadsVM = DownloadsVM(api: api)
        self.api = api
        self.service = service
    }
    
    func avatarVM(for avatar:Avatar)->AvatarVM
    {
        return AvatarVM(avatar, service: service, api: api)
    }
}

extension AvatarsVM:Equatable{
    
    static func ==(lhs: AvatarsVM, rhs: AvatarsVM) -> Bool
    {
        return lhs.api === rhs.api
    }
}
