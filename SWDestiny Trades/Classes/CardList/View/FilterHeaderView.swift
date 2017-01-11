//
//  FilterHeaderView.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 10/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import Reusable

final class FilterHeaderView: UITableViewHeaderFooterView, Reusable, BaseViewConfiguration {
    
    var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(frame: .zero)
        return segment
    }()
    
    static func height() -> CGFloat {
        return 35
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        buildViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func configureHeader() {
        segmentControl.insertSegment(withTitle: "A-Z", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "Color", at: 1, animated: false)
        //segmentControl.insertSegment(withTitle: "Price", at: 2, animated: false)
        segmentControl.insertSegment(withTitle: "Card #", at: 2, animated: false)
    }
    
    override func prepareForReuse() {
        segmentControl.removeAllSegments()
    }
    
    // MARK: <BaseViewConfiguration>
    
    internal func buildViewHierarchy() {
        self.contentView.addSubview(segmentControl)
    }
    
    internal func setupConstraints() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(self.contentView).offset(8)
            make.left.equalTo(self.contentView).offset(18)
            make.bottom.equalTo(self.contentView).offset(-8)
            make.right.equalTo(self.contentView).offset(-18)
        }
    }
    
    internal func configureViews() {
        self.backgroundColor = UIColor.white
        segmentControl.tintColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
    }
}
