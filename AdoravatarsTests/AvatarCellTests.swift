//
//  AvatarCellTests.swift
//  Adoravatars
//
//  Created by Eugene on 01.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest
import UIKit
import RxTest
import RxSwift
import RxCocoa

@testable import Adoravatars


class AvatarCellTests: XCTestCase {
    
    
    var sut:AvatarCell!

    override func setUp() {
        super.setUp()
        sut = prepareCell()
    }
    
    // MARK: Tests
    
    func testActivityIndicatorNotNil()
    {
        
        XCTAssertNotNil(sut.activityIndicator)
    }
    
    func testImageViewNotNil()
    {
       
        XCTAssertNotNil(sut.imgView)
    }
    
    
    func testTextLabelNotNil()
    {
        
        XCTAssertNotNil(sut.textLabel)
    }

    func testPrepareForReuseImageNil()
    {
        let avatarVM = AvatarVMMock()
        sut.configure(with: avatarVM)
        
        XCTAssertNotNil(sut.imgView.image)
        
        sut.prepareForReuse()
        
        XCTAssertNil(sut.imgView.image)
    }
    
    func testConfigureImageConnected()
    {
        let avatarVM = AvatarVMMock()
        sut.configure(with: avatarVM)

        XCTAssertEqual(self.sut.imgView.image, AvatarsManagerStubbed.defaultImage)

    }
    
    func testConfigureLoadingConnected()
    {
        var avatarVM = AvatarVMMock(Driver.just(true))
        sut.configure(with: avatarVM)
        
        XCTAssertTrue(sut.activityIndicator.isAnimating)
        
        avatarVM = AvatarVMMock(Driver.just(false))
        sut.configure(with: avatarVM)
        
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }
    
    
    func testConfigureTitleConnected()
    {
        let avatarVM = AvatarVMMock()
        sut.configure(with: avatarVM)
        
        
        XCTAssertEqual(self.sut.textLabel.text, AvatarsManagerStubbed.defaultAvatar.identifier)

    }
    
    // MARK: Helpers
    
    func prepareCell()->AvatarCell
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard
            .instantiateViewController(withIdentifier: "AvatarsVC")
            as! AvatarsVC
        _ = controller.view
        let collectionView = controller.collectionView
        
        return collectionView!.dequeueReusableCell(
            withReuseIdentifier: controller.cellIdentifier,
            for: IndexPath(row: 0, section: 0)) as! AvatarCell
    }
    
}
