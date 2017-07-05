//
//  DownloadCellTests.swift
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


class DownloadCellTests: XCTestCase {
    
    var sut:DownloadCell!
    
    override func setUp() {
        super.setUp()
        sut = prepareCell()
    }

    
    // MARK: Tests
    
    func testInitOutletsNotNil()
    {
        XCTAssertNotNil(sut.textLab)
        XCTAssertNotNil(sut.statusLabel)
        XCTAssertNotNil(sut.timeStampLabel)
        XCTAssertNotNil(sut.progressView)
    }
    
    
    func testConfigureTitleConnected()
    {
        let downloadVM = DownloadVM(DownloadTaskMock())
        
        sut.configureWith(downloadVM)
        
        XCTAssertEqual(sut.textLab.text, DownloadTaskMock.defaultAvatar.identifier)
    }
    
    
    func testConfigureStatusConnected()
    {
        var expectedStatus = DownloadTaskMock.defaultStatus
        var downloadVM = DownloadVM(DownloadTaskMock())
        
        sut.configureWith(downloadVM)
        
        XCTAssertEqual(sut.statusLabel.text, expectedStatus.rawValue)
        
        expectedStatus = DownloadTask.Status.failed
        
        downloadVM = DownloadVM(DownloadTaskMock(Observable.just(expectedStatus)))

        sut.configureWith(downloadVM)
        
        XCTAssertEqual(sut.statusLabel.text, expectedStatus.rawValue)
    }
    
    
    func testConfigureTimestampConnected()
    {
        let expectedDate = Date(timeIntervalSince1970: 1000)
        let downloadVM = DownloadVM(DownloadTaskMock(updatedAt: Observable.just(expectedDate)))
        
        sut.configureWith(downloadVM)
        
        XCTAssertEqual(sut.timeStampLabel.text, expectedDate.string)
    }
    
    
    func testConfigureProgressConnected()
    {
        let expectedProgress = 0.66
        let downloadVM = DownloadVM(DownloadTaskMock( events: Observable.just(DownloadTaskEvent.progress(expectedProgress))))
        
        sut.configureWith(downloadVM)
        
        XCTAssertEqual(sut.progressView.progress, Float(expectedProgress))
    }
    
    // MARK: Helpers
    
    func prepareCell()->DownloadCell
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard
            .instantiateViewController(withIdentifier: "DownloadsVC")
            as! DownloadsVC
        
        
        let downloadsVM = DownloadsVM(api: AvatarsManagerStubbed())
        controller.viewModel = downloadsVM
        
        _ = controller.view
        let tableView = controller.tableView
        
        return tableView!.dequeueReusableCell(
            withIdentifier: controller.cellIdentifier,
            for: IndexPath(row: 0, section: 0)) as! DownloadCell
    }
    
}
