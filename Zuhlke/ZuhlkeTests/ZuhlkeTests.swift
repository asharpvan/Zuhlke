//
//  ZuhlkeTests.swift
//  ZuhlkeTests
//
//  Created by #HellRaiser on 21/08/20.
//  Copyright © 2020 asharpvan. All rights reserved.
//

import XCTest
@testable import Zuhlke

class ZuhlkeTests: XCTestCase {
    
    let repository: Repository = Repository()
    let viewModel: MapScreenViewModel = MapScreenViewModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchInitialAPI() {
        
        let expect = expectation(description: "API Should Succeed")
        
        self.repository.callSingaporeTrafficCameraAPI { (result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response, "Response found nil")
                expect.fulfill()
            case.failure(let error):
                XCTAssertNil(error, "Test timeout: \(error.localizedDescription)")
                
            }
        }
        
        waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(error, "Test timeout: \(error!.localizedDescription)")
        }
        
    }
    
    func testImageFetchAPI_Success() {
        
        let expect = expectation(description: "Image should be fetched")
        let url = URL(string: "https://images.data.gov.sg/api/traffic-images/2020/08/d7cb57de-e1ba-47e2-bc60-39f475390c4f.jpg")!
        
        self.repository.fetchCameraImage(url: url) { (result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response, "Response found nil")
                expect.fulfill()
            case.failure(let error):
                XCTAssertNil(error, "Test timeout: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(error, "Test timeout: \(error!.localizedDescription)")
        }
        
    }
    
    func testImageFetchAPI_Fail() {
        
        let expect = expectation(description: "Image should not be fetched")
        let url = URL(string: "https://images.data.gov.sg/traffic-images/2020/08/d7cb57de-e1ba-47e2-bc60-39f475390c4f.jpg")!
        
        self.repository.fetchCameraImage(url: url) { (result) in
            switch result {
            case .success(let response):
                XCTAssertNil(response, "Response not found nil")
                
            case.failure(let error):
                XCTAssertNotNil(error, "error received: \(error.localizedDescription)")
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testProcess() {
        
        let errorString1 = self.viewModel.processErrorReceived(error: .badURL)
        XCTAssertEqual(errorString1, "Bad URL. Please check the URL passed")
        
        let errorString2 = self.viewModel.processErrorReceived(error: .badResponseError)
        XCTAssertEqual(errorString2, "Response received from server is not in the correct format")
        
        let errorString3 = self.viewModel.processErrorReceived(error: .parsingError)
        XCTAssertEqual(errorString3, "Couldnt Parse Data")
        
        let errorString4 = self.viewModel.processErrorReceived(error: .imageConversionError)
        XCTAssertEqual(errorString4, "Something went wrong while downloading the image")
        
        let errorString5 = self.viewModel.processErrorReceived(error: .accessDenied)
        XCTAssertEqual(errorString5, "Access Denied")
        
        
    }

}
