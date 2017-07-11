//
//  AvatarVMMock.swift
//  Adoravatars
//
//  Created by Eugene on 01.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

@testable import Adoravatars

class AvatarVMMock: AvatarVMType {    
    
    private (set) var image:Driver<UIImage?> =  Observable.just(DownloadTaskMock.defaultImage).asDriver(onErrorJustReturn: nil)
    
    private (set) var title: Driver<String> = Observable.just(DownloadTaskMock.defaultAvatar.identifier).asDriver(onErrorJustReturn: "")
    
    private (set) var loading: Driver<Bool>
    
    init(_ loading:Driver<Bool> = Driver.from([true, false])) {
        
        self.loading = loading
    }
    
    
}
