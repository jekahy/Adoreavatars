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
    
    static let cellIdentifier = "avatarCell"
    
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
    
    func configure(with vm:AvatarVMType)
    {        
        vm.image.drive(imgView.rx.image).disposed(by: disposeBag)
        vm.loading.drive(onNext: {[weak self] isLoading in
            self?.toggleActivityIndicatorStatus(isLoading)
        }).disposed(by: disposeBag)
        vm.title.drive(textLabel.rx.text).disposed(by: disposeBag)
    }
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        disposeBag = DisposeBag()
        toggleActivityIndicatorStatus(false)
        imgView.image = nil
    }
    
    
    private func toggleActivityIndicatorStatus(_ loading:Bool)
    {
        if !loading {
            activityIndicator.stopAnimating()
        }else{
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        }
        
    }
    
    
}
