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
        let task = startDownloadTask(for:avatar)
        return task.events
    }
    
    
    func getAvatars()->Observable<[Avatar]>
    {
        return AvatarsManager.defaultAvatars()
    }
    
    private func startDownloadTask(for avatar:Avatar)->DownloadTask
    {
        let request = urlRequestFor(avatar)
        
        let sessionTask = session.downloadTask(with: request)
        sessionTask.resume()

        let sessionObs = sessionObservable(for:sessionTask.taskIdentifier)
        let downloadTask = DownloadTask(taskID: sessionTask.taskIdentifier, avatar: avatar, sessionObservable:sessionObs, cache:cache)

        if let idx = downloadsVar.value.index(where: {$0.avatar == avatar}){
            downloadsVar.value[idx] = downloadTask
        }else{
            downloadsVar.value.append(downloadTask)
        }
        return downloadTask
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
