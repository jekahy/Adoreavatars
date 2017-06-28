//
//  SessionDownloadEvent.swift
//  Adoravatars
//
//  Created by Eugene on 23.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation

enum SessionDownloadEventType {
    
    case didFinishDownloading(data: Data)
    
    case didWriteData(progress:Double)
    
    case didCompleteWithError(error: Error?)
    
}


struct SessionDownloadEvent{
    
    let type:SessionDownloadEventType
    let session:URLSession
    let task:URLSessionTask
}
