//
//  DeckListViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 17/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit

final class DeckListViewController: UIViewController {
    
    fileprivate let deckListView = DeckListView()
    
    // MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = deckListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        
        deckListView.deckListTableView.didSelectDeck = { [weak self] deck in
            self?.navigateToNextController(with: deck)
        }
    }
    
    func setupNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_account"), style: .plain, target: self, action: #selector(loginButtonTouched(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouched(_:)))
    }
    
    // MARK: - <SetsListViewDelegate>
    
    func navigateToNextController(with deck: String) {
        let nextController = DeckBuilderViewController()
        //nextController.setDTO = set
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    // MARK: - UIBarButton Actions
    
    func loginButtonTouched(_ sender: Any) {
        
    }
    
    func addButtonTouched(_ sender: Any) {
        
    }
}
