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
    
    weak var manager:AvatarsManager?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        manager?.downloadTasks.bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: DownloadCell.self))
        { (index, task: DownloadTask, cell) in
            cell.configureWithTask(task)
            
            }.addDisposableTo(disposeBag)
    }

}



