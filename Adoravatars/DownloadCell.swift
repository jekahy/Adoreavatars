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
    
    
    func configureWith(_ vm:DownloadVMType)
    {
        disposeBag = DisposeBag()
        vm.title.drive(textLab.rx.text).disposed(by:disposeBag)
        vm.status.drive(statusLabel.rx.text).disposed(by: disposeBag)
        vm.timestamp.drive(timeStampLabel.rx.text).disposed(by: disposeBag)
        vm.progress.drive(progressView.rx.progress).disposed(by: disposeBag)
     }
}
