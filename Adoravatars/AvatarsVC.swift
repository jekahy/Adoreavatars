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

    let cellIdentifier = "avatarCell"
    fileprivate let toDownloadsSegue = "toDownloadsVC"
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel:AvatarsVMType = AvatarsVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewModel.title.drive(navigationItem.rx.title).disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.avatars.drive(collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AvatarCell.self)){
            [unowned self](index, avatar: Avatar, cell) in
            
            let avatarVM = AvatarVM(avatar, api: self.viewModel.api)
            cell.configure(with: avatarVM)

        }.disposed(by: disposeBag)
        
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Network", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext:{ [unowned self] _ in
            
            self.performSegue(withIdentifier: self.toDownloadsSegue, sender: nil)
            
        }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == toDownloadsSegue, let downloadsVC = segue.destination as? DownloadsVC{
            downloadsVC.viewModel = viewModel.downloadsVM
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



