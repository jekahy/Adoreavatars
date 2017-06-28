//
//  DownloadsVC.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DownloadsVC: UIViewController {
    
    fileprivate let cellIdentifier = "downloadCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let disposeBag = DisposeBag()
    
    var viewModel:DownloadsVMType!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        viewModel.downloadTasks.drive(tableView.rx.items(cellIdentifier: cellIdentifier, cellType: DownloadCell.self))
        { (index, downloadTask: DownloadTaskType, cell) in
            
            let downloadVM = DownloadVM(downloadTask)
            cell.configureWith(downloadVM)
            
            }.addDisposableTo(disposeBag)
    }

}



