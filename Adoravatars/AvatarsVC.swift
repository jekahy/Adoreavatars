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
    
    private let manager = AvatarsManager()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "Adoreavatars"
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        manager.getAvatars().bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AvatarCell.self)){ [weak self](index, avatar: Avatar, cell) in
            
            if let sSelf = self{
                cell.configure(with: avatar, api: sSelf.manager)
            }
            
        }.disposed(by: disposeBag)
        
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Network", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext:{ [unowned self] _ in
            
            self.performSegue(withIdentifier: self.toDownloadsSegue, sender: nil)
            
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == toDownloadsSegue, let downloadsVC = segue.destination as? DownloadsVC{
            downloadsVC.manager = self.manager
        }
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



