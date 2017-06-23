//
//  AvatarsManager.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation
import RxSwift

enum DownloadError:Error {
    case failed
}

class AvatarsManager:NSObject{
    
    static let shared = AvatarsManager()
    private static let mb = 1024*1024
    private let baseUrl = "http://api.adorable.io/avatar/"
    
    fileprivate let cache = URLCache(memoryCapacity: 100*mb, diskCapacity: 0, diskPath: nil)
    
    private lazy var session:URLSession = {
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = self.cache
        return URLSession(configuration: config, delegate: self.sessionDelegateObserver, delegateQueue: nil)
    }()
    
    fileprivate let downloadsVar = Variable<[DownloadTask]>([])
    private (set) lazy var downloadTasks:Observable<[DownloadTask]> = self.downloadsVar.asObservable()
    
    fileprivate let sessionDelegateObserver = URLSessionDownloadEventsObserver()
    
    private let disposeBag = DisposeBag()
    
    private override init()
    {
        super.init()
        
        sessionDelegateObserver.eventsSubject.subscribe(onNext: {[unowned self] sessionEvent in
            
            guard let dTask = self.retrieveTaskWithID(sessionEvent.task.taskIdentifier) else {
                return
            }
            
            switch sessionEvent.type {
                
            case .didWriteData(let progress):
                
                dTask.eventSubj.onNext(.progress(progress))
                
            case .didFinishDownloading(let location):
                
                guard let data = try? Data(contentsOf: location), let image = UIImage(data: data) else
                {
                    dTask.eventSubj.onError(DownloadError.failed)
                    return
                }
                self.cacheData(data, for: sessionEvent.task, cache: self.cache)
                
                dTask.eventSubj.onNext(.done(image))
                dTask.eventSubj.onCompleted()
                
            case .didCompleteWithError( let error):
                
                if let error = error {
                    dTask.eventSubj.onError(error)
                }
            }
            
            
        }).disposed(by: disposeBag)
    }
    
    
    
    func downloadAvatarImage(_ avatar:Avatar)->Observable<DownloadTaskEvent>
    {
        let task = getAvatarImage(avatar)
        return task.eventSubj.asObservable()
    }
    
    
    func getAvatars()->Observable<[Avatar]>
    {
        return AvatarsManager.defaultAvatars()
    }
    
    func getAvatarImage(_ avatar:Avatar)->DownloadTask
    {
        let request = urlRequestFor(avatar)
        
        let sessionTask = session.downloadTask(with: request)
        sessionTask.resume()

        let downloadTask = DownloadTask(taskID: sessionTask.taskIdentifier, avatar: avatar)

        if let idx = downloadsVar.value.index(where: {$0.avatar == avatar}){
            downloadsVar.value[idx] = downloadTask
        }else{
            downloadsVar.value.append(downloadTask)
        }
        return downloadTask
    }
    
    
//    MARK: Helpers
    
    private func urlForAvatarID(_ id:String)->URL
    {
        var path = baseUrl + id
        path = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        return URL(string:path)!
    }
    
    private func urlRequestFor(_ avatar:Avatar)->URLRequest
    {
        let url = urlForAvatarID(avatar.identifier)
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
    }
    
    
    private func retrieveTaskWithID(_ taskID:Int)->DownloadTask?
    {
        return downloadsVar.value.first(where: {$0.taskID == taskID})
    }
    
    
    private func cacheData(_ data:Data, for task:URLSessionTask, cache:URLCache)
    {
        if let response = task.response, let request = task.originalRequest{
            let cached = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cached, for: request)
        }
    }
}


extension AvatarsManager{
    
    static func defaultAvatars()->Observable<[Avatar]>
    {
        let avatars = ["Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "Leia Organa", "Owen Lars", "Beru Whitesun lars", "R5-D4", "Biggs Darklighter", "Obi-Wan Kenobi", "Anakin Skywalker", "Wilhuff Tarkin", "Chewbacca", "Han Solo", "Greedo", "Jabba Desilijic Tiure", "Wedge Antilles", "Jek Tono Porkins", "Yoda", "Palpatine", "Boba Fett", "IG-88", "Bossk", "Lando Calrissian", "Lobot", "Ackbar", "Mon Mothma", "Arvel Crynyd", "Wicket Systri Warrick", "Nien Nunb", "Qui-Gon Jinn", "Nute Gunray", "Finis Valorum", "Jar Jar Binks", "Roos Tarpals", "Rugor Nass", "Ric Olié", "Watto", "Sebulba", "Quarsh Panaka", "Shmi Skywalker", "Darth Maul", "Bib Fortuna", "Ayla Secura", "Dud Bolt", "Gasgano", "Ben Quadinaros", "Mace Windu", "Ki-Adi-Mundi", "Kit Fisto", "Eeth Koth", "Adi Gallia", "Saesee Tiin", "Yarael Poof", "Plo Koon", "Mas Amedda", "Gregar Typho", "Cordé", "Cliegg Lars", "Poggle the Lesser", "Luminara Unduli", "Barriss Offee", "Dormé", "Dooku", "Bail Prestor Organa", "Jango Fett", "Zam Wesell", "Dexter Jettster", "Lama Su", "Taun We", "Jocasta Nu", "Ratts Tyerell", "R4-P17", "Wat Tambor", "San Hill", "Shaak Ti", "Grievous", "Tarfful", "Raymus Antilles", "Sly Moore", "Tion Medon", "Finn", "Rey", "Poe Dameron", "BB8", "Captain Phasma", "Padmé Amidala"].map({Avatar(identifier:$0)})
        return Observable.just(avatars)
    }
}
