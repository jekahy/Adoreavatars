//
//  DownloadsVC.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import Foundation
import UIKit


class DownloadsVC: UIViewController {
    
    fileprivate let cellIdentifier = "downloadCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var downloadTasks = [DownloadTask]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        downloadTasks = getDownloads()
        tableView.reloadData()
    }
    
    
    private func getDownloads()->[DownloadTask]
    {
        let api = AvatarsManager.shared
        return Array(api.downloadTasks)
    }
}

extension DownloadsVC:UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return downloadTasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DownloadCell else {
            return UITableViewCell()
        }
        let task = downloadTasks[indexPath.row]
        cell.configureWithTask(task)
        return cell
    }
    
}


