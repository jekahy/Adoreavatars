//
//  AvatarsVCTests.swift
//  Adoravatars
//
//  Created by Eugene on 01.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest

@testable import Adoravatars

class AvatarsVCTests: XCTestCase {
    
    var sut:AvatarsVC!
    
    override func setUp() {
        super.setUp()
        sut = createSut(type: AvatarsVC.self)
    }
    
    // MARK: Tests
    
    func testInitCollectionViewNotNil()
    {
        XCTAssertNotNil(sut.collectionView)
    }
    
    func testInitViewModelNotNil()
    {
        XCTAssertNotNil(sut.viewModel)
    }
    
    
    func testInitCollectionViewRxDelegateSet()
    {
        let expected  = sut.collectionView.rx.delegate.forwardToDelegate()
        XCTAssertNotNil(expected)
    }
    
    
    func testInitItemsConnected()
    {
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 1)
    }
    
    
    // MARK: Helpers
    
    func createSut<T>(type:T.Type)->T where T:AvatarsVC
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let avatarsVM = AvatarsVM(service:AvatarServiceStubbed())
        let controller = storyboard
            .instantiateViewController(withIdentifier: "AvatarsVC")
            as! T
        controller.viewModel = avatarsVM
        _ = controller.view
        return controller
    }
    
}
