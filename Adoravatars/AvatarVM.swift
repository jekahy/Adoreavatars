
//
//  AvatarVM.swift
//  Adoravatars
//
//  Created by Eugene on 25.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import RxSwift
import RxCocoa
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
    
    
    init(_ avatar:Avatar, api: AvatarsProvider) {
        
        title = Driver.just(avatar.identifier)

        image = api.downloadAvatarImage(avatar).image.asDriver(onErrorJustReturn: nil)
        
        loading = api.downloadAvatarImage(avatar).status
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
