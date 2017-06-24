//
//  AvatarCell.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit
import RxSwift

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
        toggleActivityIndicatorStatus(false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.setNeedsLayout()
        imgView.layoutIfNeeded()
        imgView.layer.cornerRadius = imgView.bounds.size.width/2
        imgView.layer.masksToBounds = true
    }
    
    func configure(with avatar:Avatar, api:AvatarsManager)
    {
        api.downloadAvatarImage(avatar)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] event in
                
                if case .done(let image) = event {
                    self?.imgView.image = image
                    self?.toggleActivityIndicatorStatus(true)
                }
                
                }, onError: {[weak self] error in
                    
                    self?.toggleActivityIndicatorStatus(true)
                    
            }).disposed(by: disposeBag)
        
        textLabel.text = avatar.identifier
    }
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        disposeBag = DisposeBag()
        toggleActivityIndicatorStatus(false)
        imgView.image = nil
        
    }
    
    
    
    private func toggleActivityIndicatorStatus(_ stop:Bool)
    {
        if stop {
            activityIndicator.stopAnimating()
        }else{
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        }
        
    }
    
    
}
