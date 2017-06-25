//
//  DownloadCell.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DownloadCell: UITableViewCell {

    
    @IBOutlet weak var textLab: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    private var disposeBag = DisposeBag()
    
    
    func configureWithTask(_ task:DownloadTask)
    {
        disposeBag = DisposeBag()
        textLab.text = task.avatar.identifier
        statusLabel.text = task.status.rawValue
        progressView.progress = 0

        task.events
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] event in
                
                if case .progress(let progress) = event {
                    self?.progressView.progress = Float(progress)
                }
            
            }, onError: {[weak self] _ in
            
                self?.progressView.progress = 0
            
            }, onCompleted:{ [weak self] in
                
                self?.progressView.progress = 1
                
            }).disposed(by: disposeBag)
        
        task.events.observeOn(MainScheduler.instance).subscribe { [weak task, weak self] _ in
            self?.timeStampLabel.text = task?.updatedAt.string
            self?.statusLabel.text = task?.status.rawValue
        }.disposed(by: disposeBag)
    }
}
