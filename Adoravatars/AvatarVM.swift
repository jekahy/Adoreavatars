
//
//  AvatarVM.swift
//  Adoravatars
//
//  Created by Eugene on 25.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import Foundation

protocol AvatarVMType:class {
    
    var image:Driver<UIImage?>{get}
    var loading:Driver<Bool>{get}
    var title:Driver<String>{get}
}

class AvatarVM:AvatarVMType  {
    
    let title:Driver<String>
    let loading:Driver<Bool>
    let image:Driver<UIImage?>
    
    init(_ avatar:Avatar, service: AvatarsGettable, api:APIDownloadable) {
        
        title = Driver.just(avatar.identifier)

        image = service.downloadAvatarImage(avatar, api:api).data.unwrap().map{UIImage(data: $0)}.asDriver(onErrorJustReturn: nil)
        
        loading = service.downloadAvatarImage(avatar, api: api).status
            .map({ status -> Bool in
                switch status{
                    case .inProgress, .queued: return true
                    default:        return false
                }
            })
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
    }
}
