//
//  SetsListInteractorTests.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 29/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
import UIKit

@testable import SWDestinyTrades

final class SetsListInteractorTests: AsyncSpec {

    override class func spec() {

        var sut: SetsListInteractor!
        var service: SWDestinyService!
        var client: HttpClientMock!

        describe("SetsListInteractor") {

            beforeEach {
                client = HttpClientMock()
                service = SWDestinyService(client: client)
                sut = SetsListInteractor(service: service)
            }

            it("should retrieve the set list with success") {
                let setList = try await sut.retrieveSets()
                expect(setList.count) == 20
            }

            it("should fail to retrieve the set list") {
                client.error = true
                await expect { try await sut.retrieveSets() }.to(throwError())
            }
        }
    }
}
