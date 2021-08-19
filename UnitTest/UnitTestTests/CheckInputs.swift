//
//  CheckInputs.swift
//  UnitTestTests
//
//  Created by Mike Sedaghatnia on 2021-08-08.
//
@testable import UnitTest
import XCTest

class CheckInputs: XCTestCase {
    
    var testStruct: ValidateUserNameAndPassword!
    
    override func setUp() {
        super.setUp()
        testStruct = ValidateUserNameAndPassword()
        
    }
    
    override func tearDown() {
        testStruct = nil
        super.tearDown()
    }
    
    func test_username_is_valid() throws {
        XCTAssertNoThrow(try testStruct.checkValidation(username: "mmmmmmmmmm1"))
        
    }
    
    func test_username_is_not_nil() throws {
        let expectedErrors = checkValidate.invalidInput
        var error: checkValidate?
        XCTAssertThrowsError(try testStruct.checkValidation(username: nil)) { throwError in
            error = throwError as? checkValidate
        }
        
        XCTAssertEqual(error, expectedErrors)
    }
    
    
    func test_pass_is_repeated() throws {
        XCTAssertNoThrow(try testStruct.checkPassValidation(pass: "rr1"))
    }
    
    func test_pass_is_nil() throws {
        let expectedError = checkValidate.passRepeated
        var error: checkValidate?
        
        XCTAssertThrowsError(try testStruct.checkPassValidation(pass: "rr1")) { throwError in
            error = throwError as? checkValidate
        }
        
        XCTAssertEqual(error, expectedError)
    }
    
    
    func test_api_url() throws {
        let expect = expectation(description: "Network Request done!")
        let url = "https://www.reddit.com/r/aww/nmkokokokonew.json"
        testStruct.getData(inputUrl: url) { result in
            expect.fulfill()
            switch result {
            case .success(let data):
                print(data.count)
                XCTAssertNotNil(data)
            case .failure(let error):
                print(error.localizedDescription)
                XCTAssertNotNil(error, error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}
