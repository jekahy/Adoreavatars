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
    @IBOutlet weak var progressView: UIProgressView!
    
    private var disposeBag = DisposeBag()
    
    
    func configureWithTask(_ task:DownloadTask)
    {
        disposeBag = DisposeBag()
        textLab.text = task.avatar.identifier
        statusLabel.text = task.state.rawValue
        if task.state != .done
        {
            task.progressSubj.observeOn(MainScheduler.instance).subscribe(onNext: {[weak self] progress in
                    self?.progressView.progress = Float(progress)
                
            }).disposed(by: disposeBag)
            
            task.completionSubj.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] _ in

                self?.statusLabel.text = task.state.rawValue
                
            }, onError: { [weak self] _ in

                self?.statusLabel.text = task.state.rawValue
                
            }).disposed(by: disposeBag)

        }else{
            progressView.progress = 1
        }
    }
}
