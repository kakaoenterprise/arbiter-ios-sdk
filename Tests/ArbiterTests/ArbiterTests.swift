import XCTest
@testable import Arbiter

final class ArbiterTests: XCTestCase {
    func test_fetchXid() {
        print(Bundle.main.bundleIdentifier)
        let expectation = XCTestExpectation()
        KepArbiter.fetchUser { xid in
            XCTAssertNotNil(xid)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_fetchActionEventsWithoutSdkKey() {
        let expectation = XCTestExpectation()
        KepArbiter.fetchActionEvents { actionEvents in
            XCTAssertNil(actionEvents)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_fetchActionEventsWithSdkKey() {
        KepArbiter.sdkKey = KeyParserUtil.parseKey("aWQ9MCZ0ZW5hbnQ9S0VQJmFwaUtleT10ZXN0X3JhbmRvbV9hcGlfa2V5JmlzRGV2PTE=") ?? SdkKey()
        let expectation = XCTestExpectation()
        KepArbiter.fetchActionEvents { actionEvents in
            XCTAssertNotNil(actionEvents)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_fetchVariaion() {
        KepArbiter.initialize(sdkKey: "aWQ9MCZ0ZW5hbnQ9S0VQJmFwaUtleT10ZXN0X3JhbmRvbV9hcGlfa2V5JmlzRGV2PTE=")
        var responseData: Data? = nil
        let expectation = XCTestExpectation()
        KepArbiter.fetchVariation(token: "VoGdldDZLX") { result in
            XCTAssertNotNil(result.response)
            switch result.result {
            case .success(let data):
                responseData = data
            case .failure(let error):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        XCTAssertEqual(String(data: responseData!, encoding: .utf8), "red")
    }
    
    
    func test_test() {
            XCTFail()
    }
    
}
