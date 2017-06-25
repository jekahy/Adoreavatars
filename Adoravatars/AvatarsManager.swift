//
//  AvatarsManager.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

enum DownloadError:Error {
    case failed
}

class AvatarsManager{
    
    private let baseURL:URL
    private let sessionConfig:URLSessionConfiguration
    private let cache:URLCache
    
    private lazy var session:URLSession = {
        
        let config = self.sessionConfig
        config.urlCache = self.cache
        return URLSession(configuration: config, delegate: self.sessionDelegateObserver, delegateQueue: nil)
    }()
    
    fileprivate let downloadsVar = Variable<[DownloadTask]>([])
    private (set) lazy var downloadTasks:Observable<[DownloadTask]> = self.downloadsVar.asObservable()
    
    fileprivate let sessionDelegateObserver = URLSessionDownloadEventsObserver()
    fileprivate lazy var sessionEventsObservable: Observable<SessionDownloadEvent> = self.sessionDelegateObserver.sessionEvents
    
    
    init(baseURL:URL=AvatarsManager.defaultBaseURL, sessionConfiguration:URLSessionConfiguration=AvatarsManager.defaultSessionConfiguration, cache:URLCache=AvatarsManager.defaultCache)
    {
        self.baseURL = baseURL
        self.sessionConfig = sessionConfiguration
        self.cache = cache
    }
    
    func downloadAvatarImage(_ avatar:Avatar)->Observable<DownloadTaskEvent>
    {
        if let task = self.downloadsVar.value.first(where: {$0.avatar == avatar}){
            return task.events
        }
        
        let taskEventsObservable = Observable.just(avatar)
            .map({[weak self] avatar -> URLRequest? in
                self?.urlRequestFor(avatar)})
            .unwrap()
            .map({[weak self] request -> URLSessionDownloadTask? in
                guard let strSelf = self else{
                    return nil
                }
                let sessionTask = strSelf.session.downloadTask(with: request)
                sessionTask.resume()
                return sessionTask
            })
            .unwrap()
            .flatMap({[weak self] sessionTask -> Observable<SessionDownloadEvent> in
                
                self?.sessionObservable(for:sessionTask.taskIdentifier) ?? Observable.never()
            })
            .flatMap({[weak self] sessionEvent -> Observable<DownloadTaskEvent> in
                
                guard let strSelf = self else{
                    return Observable.never()
                }
                return strSelf.handleSessionEvent(sessionEvent, cache: strSelf.cache)
            })
            .takeWhile({!$0.didComplete()})
            .shareReplay(1)
        
        
        let downloadTask = DownloadTask(avatar: avatar, eventsObservable:taskEventsObservable)
        self.downloadsVar.value.append(downloadTask)
        return taskEventsObservable
    }
    
    
    func getAvatars()->Observable<[Avatar]>
    {
        return AvatarsManager.defaultAvatars()
    }
}

extension AvatarsManager {

    //    MARK: Helpers

    fileprivate func urlForAvatarID(_ id:String, baseURL:URL=AvatarsManager.defaultBaseURL)->URL
    {
        return baseURL.appendingPathComponent(id)
    }
    
    fileprivate func urlRequestFor(_ avatar:Avatar)->URLRequest
    {
        let url = urlForAvatarID(avatar.identifier)
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
    }
    
    
    fileprivate func sessionObservable(for taskID:Int)->Observable<SessionDownloadEvent>
    {
        return sessionEventsObservable.filter({$0.task.taskIdentifier == taskID})
        
    }
    
    
    fileprivate func handleSessionEvent(_ sessionEvent:SessionDownloadEvent,  cache:URLCache)-> Observable<DownloadTaskEvent>
    {
        return Observable.create { [weak self] observer -> Disposable in
            
            switch sessionEvent.type {
                
            case .didWriteData(let progress):
                
                observer.onNext(.progress(progress))
                
            case .didFinishDownloading(let location):
                
                guard let data = try? Data(contentsOf: location), let image = UIImage(data: data) else
                {
                    observer.onError(DownloadError.failed)
                    break
                }
                self?.cacheData(data, for: sessionEvent.task, cache: cache)
                observer.onNext(.done(image))
                observer.onNext(.finish)
                
            case .didCompleteWithError( let error):
                
                if let error = error {
                    observer.onError(error)
                }
                observer.onNext(.finish)
            }
            return Disposables.create()
        }
        
    }
    
    fileprivate func cacheData(_ data:Data, for task:URLSessionTask, cache:URLCache)
    {
        if let response = task.response, let request = task.originalRequest{
            let cached = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cached, for: request)
        }
    }

}


extension AvatarsManager{
    
    fileprivate static let mb = 1024*1024
    
    fileprivate static let defaultCache = URLCache(memoryCapacity: 100*mb, diskCapacity: 0, diskPath: nil)
    
    fileprivate static var defaultSessionConfiguration:URLSessionConfiguration{
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = AvatarsManager.defaultCache
        return config
    }
    fileprivate static let defaultBaseURL = URL(string: "http://api.adorable.io/avatar")!

    static func defaultAvatars()->Observable<[Avatar]>
    {
        let avatars = ["Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "Leia Organa", "Owen Lars", "Beru Whitesun lars", "R5-D4", "Biggs Darklighter", "Obi-Wan Kenobi", "Anakin Skywalker", "Wilhuff Tarkin", "Chewbacca", "Han Solo", "Greedo", "Jabba Desilijic Tiure", "Wedge Antilles", "Jek Tono Porkins", "Yoda", "Palpatine", "Boba Fett", "IG-88", "Bossk", "Lando Calrissian", "Lobot", "Ackbar", "Mon Mothma", "Arvel Crynyd", "Wicket Systri Warrick", "Nien Nunb", "Qui-Gon Jinn", "Nute Gunray", "Finis Valorum", "Jar Jar Binks", "Roos Tarpals", "Rugor Nass", "Ric Olié", "Watto", "Sebulba", "Quarsh Panaka", "Shmi Skywalker", "Darth Maul", "Bib Fortuna", "Ayla Secura", "Dud Bolt", "Gasgano", "Ben Quadinaros", "Mace Windu", "Ki-Adi-Mundi", "Kit Fisto", "Eeth Koth", "Adi Gallia", "Saesee Tiin", "Yarael Poof", "Plo Koon", "Mas Amedda", "Gregar Typho", "Cordé", "Cliegg Lars", "Poggle the Lesser", "Luminara Unduli", "Barriss Offee", "Dormé", "Dooku", "Bail Prestor Organa", "Jango Fett", "Zam Wesell", "Dexter Jettster", "Lama Su", "Taun We", "Jocasta Nu", "Ratts Tyerell", "R4-P17", "Wat Tambor", "San Hill", "Shaak Ti", "Grievous", "Tarfful", "Raymus Antilles", "Sly Moore", "Tion Medon", "Finn", "Rey", "Poe Dameron", "BB8", "Captain Phasma", "Padmé Amidala"].map({Avatar(identifier:$0)})
        return Observable.just(avatars)
    }
    
    
    
}
