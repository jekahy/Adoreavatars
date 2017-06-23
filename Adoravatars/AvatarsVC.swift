//
//  ViewController.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AvatarsVC: UIViewController {

    fileprivate let cellIdentifier = "avatarCell"
    fileprivate let toDownloadsSegue = "toDownloadsVC"
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let manager = AvatarsManager.shared
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "Adoreavatars"
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        manager.getAvatars().bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AvatarCell.self)){ (index, avatar: Avatar, cell) in
            
            cell.configure(with: avatar, api: AvatarsManager.shared)
            
        }.disposed(by: disposeBag)
        
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Network", style: .plain, target: self, action: #selector(networkButtonTapped))
    }
    
    
    @objc
    private func networkButtonTapped ()
    {
        performSegue(withIdentifier: toDownloadsSegue, sender: nil)
    }

  }

extension AvatarsVC:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = view.frame.size.width/3-10
        return CGSize(width:w , height: w)
    }

}



