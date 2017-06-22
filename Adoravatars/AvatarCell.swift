//
//  AvatarCell.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxSwiftExt

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    private (set) var avatar:Avatar!
    
    func configure(with avatar:Avatar, api:AvatarsManager)
    {
        disposeBag = DisposeBag()

        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        imgView.image = nil

        api.downloadAvatarImage(avatar)
            .observeOn(MainScheduler.instance)
            .unwrap()
            .subscribe(onNext: {[weak self] image in
                
            self?.imgView.image = image
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true

        }, onError: {[weak self] error in
            
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true


        }).disposed(by: disposeBag)
        
        textLabel.text = avatar.identifier
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.layer.cornerRadius = imgView.bounds.size.width/2
        imgView.layer.masksToBounds = true
    }
    
    
}
