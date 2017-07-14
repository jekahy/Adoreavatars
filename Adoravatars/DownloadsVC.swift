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
import Then

class DownloadsVC: UIViewController {
    
    let cellIdentifier = "downloadCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()

    private var viewModel:DownloadsVMType!
    private var navigator:Navigator!
    
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
    
    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: DownloadsVMType) -> DownloadsVC {
        
        return storyboard.instantiateViewController(ofType: DownloadsVC.self).then { vc in
            vc.navigator = navigator
            vc.viewModel = viewModel
        }
    }

}



