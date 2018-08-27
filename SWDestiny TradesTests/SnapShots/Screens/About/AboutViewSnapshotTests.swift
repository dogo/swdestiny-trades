//
//  AboutViewSnapshotTests.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 27/08/18.
//  Copyright © 2018 Diogo Autilio. All rights reserved.
//

import Quick
import Nimble
//import Nimble_Snapshots

@testable import SWDestiny_Trades

class AboutViewSnapshotTests: QuickSpec {
    
    override func spec() {
        
        var sut: AboutView!
        var window: UIWindow!
        
        describe("AboutView layout") {
            
            beforeSuite {
                window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 564))
                window.makeKeyAndVisible()
            }
            
            afterSuite {
                window.isHidden = true
                window = nil
            }
            
            context("when it's initialized") {
                
                beforeEach {
                    sut = AboutView(frame: .zero)
                    sut.frame = window.frame
                }
                
                it("should have valid layout") {
                    expect(sut) == snapshot("About View")
                }
            }
            
            context("when URL link it's touched") {
            
                it("should call closure when press add button") {
                    sut = AboutView(frame: .zero)
                    sut.widthAnchor.constraint(equalToConstant: 320).isActive = true
                    
                    var touched = false
                    sut.didTouchHTTPLink = { [weak self] url in
                        touched = true
                    }
                    
                    //sut.addButton.sendActions(for: .touchUpInside)
                    
                    expect(touched) == true
                }
            }
        }
    }
}
