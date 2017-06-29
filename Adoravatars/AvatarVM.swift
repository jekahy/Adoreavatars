
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
    
    private let disposeBag = DisposeBag()
    
    let title:Driver<String>
    let loading:Driver<Bool>
    let image:Driver<UIImage?>
    
    
    init(_ avatar:Avatar, api: AvatarsProvider) {
        
        title = Driver.just(avatar.identifier)

        image = api.downloadAvatarImage(avatar)
            .map({ downloadEvent -> UIImage? in
                if case .done(let img) = downloadEvent{
                    return img
                }
                return nil
            }).asDriver(onErrorJustReturn: nil)
        
        loading = api.downloadAvatarImage(avatar)
            .map({ downloadEvent -> Bool in
                switch downloadEvent{
                case .progress: return true
                default:        return false
                }
            })
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
    }
}
