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
    
    typealias DTM = DownloadTaskMock
    
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
        let downloadVM = DownloadVM(DTM())
        
        sut.configureWith(downloadVM)
        
        XCTAssertEqual(sut.textLab.text, FDP.defaultAvatar.identifier)
    }
    
    
    func testConfigureStatusConnected()
    {
        var expectedStatus = FDP.defaultStatus
        var downloadVM = DownloadVM(DTM())
        
        sut.configureWith(downloadVM)
        
        XCTAssertEqual(sut.statusLabel.text, expectedStatus.rawValue)
        
        expectedStatus = DownloadTask.Status.failed
        
        downloadVM = DownloadVM(DTM(Observable.just(expectedStatus)))

        sut.configureWith(downloadVM)
        
        XCTAssertEqual(sut.statusLabel.text, expectedStatus.rawValue)
    }
    
    
    func testConfigureTimestampConnected()
    {
        let expectedDate = Date(timeIntervalSince1970: 1000)
        let downloadVM = DownloadVM(DTM(updatedAt: Observable.just(expectedDate)))
        
        sut.configureWith(downloadVM)
        
        XCTAssertEqual(sut.timeStampLabel.text, expectedDate.string)
    }
    
    
    func testConfigureProgressConnected()
    {
        let expectedProgress = 0.66
        let downloadVM = DownloadVM(DTM(progress: Observable.just(expectedProgress)))
        
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
        
        
        let downloadsVM = DownloadsVM(api: APIServiceStubbed())
        controller.viewModel = downloadsVM
        
        _ = controller.view
        let tableView = controller.tableView
        
        return tableView!.dequeueReusableCell(
            withIdentifier: controller.cellIdentifier,
            for: IndexPath(row: 0, section: 0)) as! DownloadCell
    }
    
}
