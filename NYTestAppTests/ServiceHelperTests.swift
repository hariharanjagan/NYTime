//
//  ServiceHelperTests.swift
//  NYTestAppTests
//
//  Created by Hariharan jaganathan on 12/08/19.
//  Copyright © 2019 Hariharan jaganathan. All rights reserved.
//

import XCTest

@testable import NYTestApp

class ServiceHelperTests: XCTestCase {
    
    func testCancelRequest() {
        
        // giving a "previous" session
        ServiceHelper.shared.fetchArticles { (_) in
            // ignore call
        }
        
        // Expected to task nil after cancel
        ServiceHelper.shared.cancelFetchArticles()
        XCTAssertNil(ServiceHelper.shared.task, "Expected task nil")
    }
}
