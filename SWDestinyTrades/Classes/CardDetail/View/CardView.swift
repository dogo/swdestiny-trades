//
//  CardView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 05/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import ImageSlideshow
import UIKit

protocol CardDetailViewProtocol: AnyObject {
    func setSlideshowImageInputs(_ imageInputs: [InputSource])
    func setCurrentPage(_ page: Int, animated: Bool)
    func getCurrentPage() -> Int
    func getCurrentSlideshowItem() -> ImageSlideshowItem?
    func setNavigationTitle(_ title: String)
    func showSuccessMessage(card: CardDTO)
    func presentViewController(_ controller: UIViewController, animated: Bool)
}

final class CardView: UIView, CardViewType {

    var currentPageChanged: ((_ page: Int) -> Void)? {
        didSet {
            slideshow.currentPageChanged = currentPageChanged
        }
    }

    private let slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow(frame: .zero)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.backgroundColor = .blackWhite
        slideshow.contentScaleMode = .scaleAspectFit
        slideshow.pageIndicator = nil
        slideshow.circular = false
        slideshow.preload = .fixed(offset: 1)
        return slideshow
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSlideshowImageInputs(_ imageInputs: [InputSource]) {
        slideshow.setImageInputs(imageInputs)
    }

    func setCurrentPage(_ page: Int, animated: Bool) {
        slideshow.setCurrentPage(page, animated: animated)
    }

    func getCurrentPage() -> Int {
        return slideshow.currentPage
    }

    func getCurrentSlideshowItem() -> ImageSlideshowItem? {
        return slideshow.currentSlideshowItem
    }
}

extension CardView: BaseViewConfiguration {

    func buildViewHierarchy() {
        addSubview(slideshow)
    }

    func setupConstraints() {
        slideshow.layout.applyConstraint { view in
            view.topAnchor(equalTo: self.safeTopAnchor)
            view.leadingAnchor(equalTo: self.leadingAnchor)
            view.bottomAnchor(equalTo: self.safeBottomAnchor)
            view.trailingAnchor(equalTo: self.trailingAnchor)
        }
    }

    func configureViews() {
        backgroundColor = .blackWhite
    }
}
