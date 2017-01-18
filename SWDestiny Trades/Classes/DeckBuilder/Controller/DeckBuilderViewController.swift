//
//  DeckBuilderViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 17/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckBuilderViewController: UIViewController {
    
    fileprivate let deckBuilderView = DeckBuilderView()
    
    // MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = deckBuilderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTouched(_:)))
    }
    
    // MARK: - UIBarButton Actions
    
    func saveButtonTouched(_ sender: Any) {
        
    }
}
