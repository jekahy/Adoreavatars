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
import Then

class AvatarsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel:AvatarsVMType = AvatarsVM()
    private var navigator:Navigator = Navigator()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewModel.title.drive(navigationItem.rx.title).disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.avatars.drive(collectionView.rx.items(cellIdentifier: AvatarCell.cellIdentifier, cellType: AvatarCell.self)){
            [unowned self](index, avatar: Avatar, cell) in
            
            let avatarVM = self.viewModel.avatarVM(for:avatar)
            cell.configure(with: avatarVM)

        }.disposed(by: disposeBag)
        
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Network", style: .plain, target: nil, action: nil)

        navigationItem.rightBarButtonItem?.rx.tap
            .throttle(1, latest: true, scheduler: MainScheduler.instance)
            .subscribe(onNext:{ [unowned self] _ in
            
                self.navigator.show(segue: .downloadsList(self.viewModel.api), sender: self)
            
        }).disposed(by: disposeBag)
    }
    
    
    static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: AvatarsVMType) -> AvatarsVC {
        
        return storyboard.instantiateViewController(ofType: AvatarsVC.self).then { vc in
            vc.navigator = navigator
            vc.viewModel = viewModel
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



