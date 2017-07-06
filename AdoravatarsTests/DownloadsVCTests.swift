//
//  DownloadsVCTests.swift
//  Adoravatars
//
//  Created by Eugene on 06.07.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import XCTest

@testable import Adoravatars

class DownloadsVCTests: XCTestCase {
    
    var sut:DownloadsVC!
    
    override func setUp() {
        super.setUp()
        let downloadsVM = DownloadsVM(api: AvatarsManagerStubbed())
        sut = createSut(vm: downloadsVM)
    }
    
//    MARK: Tests
    
    func testInitTableViewNotNil()
    {
        XCTAssertNotNil(sut.tableView)
    }
    
    
    func testInitViewModelNotNil()
    {
        XCTAssertNotNil(sut.viewModel)
    }
    
    
    func testInitDownloadTasksConnected()
    {
        let rows = sut.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(rows, 1)
    }
    
    
//    MARK: Helpers
 
    func createSut(vm:DownloadsVMType)->DownloadsVC
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard
            .instantiateViewController(withIdentifier: "DownloadsVC")
            as! DownloadsVC
        controller.viewModel = vm
        _ = controller.view
        return controller
    }
}
