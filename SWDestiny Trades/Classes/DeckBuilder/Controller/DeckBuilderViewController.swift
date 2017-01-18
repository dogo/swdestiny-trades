//
//  DeckBuilderViewController.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 17/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import UIKit
import RealmSwift

final class DeckBuilderViewController: UIViewController {
    
    var deckDTO: DeckDTO?
    fileprivate var deckList = [CardDTO]()
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
        
        if deckDTO == nil {
            deckDTO = DeckDTO()
        }
        
        loadData(list: Array(deckDTO!.list))
        
        deckBuilderView.deckBuilderTableView.didSelectAddItem = { [weak self] in
            self?.navigateToAddCardViewController()
        }
        
        deckBuilderView.deckBuilderTableView.didSelectCard = { [weak self] card in
            self?.navigateToCardDetailViewController(with: card)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(DeckBuilderViewController.reloadTableView), name:NotificationKey.reloadTableViewNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let path = deckBuilderView.deckBuilderTableView.indexPathForSelectedRow {
            deckBuilderView.deckBuilderTableView.deselectRow(at: path, animated: animated)
        }
    }
    
    func setupNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTouched(_:)))
    }
    
    func loadData(list: [CardDTO]) {
        deckList = list
        deckBuilderView.deckBuilderTableView.updateTableViewData(deckList: list)
    }
    
    @objc private func reloadTableView(_ notification: NSNotification) {
        if let deckList = notification.userInfo?["deckDTO"] as? [CardDTO] {
            loadData(list: deckList)
        }
    }
    
    // MARK: - UIBarButton Actions
    
    func saveButtonTouched(_ sender: Any) {
        if deckList.count > 0 {
            let realm = try! Realm()
            try! realm.write {
                for card in deckList {
                    deckDTO?.list.append(card)
                }
                realm.add(deckDTO!, update: true)
            }
        }
    }
    
    // MARK: Navigation
    
    func navigateToCardDetailViewController(with card: CardDTO?) {
        let nextController = CardDetailViewController()
        nextController.cardDTO = card
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    func navigateToAddCardViewController() {
        let nextController = AddCardViewController()
        nextController.isDeckBuilder = true
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}
