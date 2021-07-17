//
//  GitHubRepositorySearchSwiftUITests.swift
//  GitHubRepositorySearchSwiftUITests
//
//  Created by yorifuji on 2021/06/07.
//

import XCTest
import Combine
@testable import GitHubRepositorySearchSwiftUI

class GitHubRepositorySearchSwiftUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample_GitHubレポジトリからyoirfujiを検索する() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var cancellables: Set<AnyCancellable> = []
        SearchRepositoryClient.searchRepository("yorifuji")
            .sink { completion in
                print(completion)
                cancellables.removeAll()
            } receiveValue: { response in
                print(response)
                print(response.totalCount)
            }
            .store(in: &cancellables)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
