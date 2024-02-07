//
//  SetsListPresenter.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 28/11/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation

protocol SetsPresenterProtocol {
    func viewDidLoad()
    func retrieveSets()
    func aboutButtonTouched()
    func searchButtonTouched()
    func didSelectSet(_ set: SetDTO)
}

final class SetsListPresenter: SetsPresenterProtocol {

    private weak var controller: SetsListViewControllerProtocol?
    private let interactor: SetsListInteractorProtocol
    private let database: DatabaseProtocol?
    private let navigator: SetsListNavigator

    init(controller: SetsListViewControllerProtocol,
         interactor: SetsListInteractorProtocol,
         database: DatabaseProtocol?,
         navigator: SetsListNavigator) {
        self.controller = controller
        self.interactor = interactor
        self.database = database
        self.navigator = navigator
    }

    func viewDidLoad() {
        controller?.startLoading()
        controller?.setupNavigationItem()
        retrieveSets()
    }

    func retrieveSets() {
        Task { [weak self] in
            do {
                guard let self else { return }

                let setList = try await interactor.retrieveSets()

                await MainActor.run { [weak self] in
                    self?.controller?.updateSetList(setList)
                    self?.controller?.stopLoading()
                    self?.controller?.endRefreshControl()
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.controller?.showNetworkErrorMessage()
                    LoggerManager.shared.log(event: .setsList, parameters: ["error": error.localizedDescription])
                    self?.controller?.stopLoading()
                    self?.controller?.endRefreshControl()
                }
            }
        }
    }

    func didSelectSet(_ set: SetDTO) {
        navigator.navigate(to: .cardList(database: database, with: set))
    }

    func aboutButtonTouched() {
        navigator.navigate(to: .about)
    }

    func searchButtonTouched() {
        navigator.navigate(to: .search(database: database))
    }
}
