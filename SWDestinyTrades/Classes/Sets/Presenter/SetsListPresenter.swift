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

final class SetsPresenter: SetsPresenterProtocol {

    weak var view: SetsViewProtocol?
    private let interactor: SetsInteractorProtocol
    private let database: DatabaseProtocol?
    private let navigator: SetsListNavigator

    init(view: SetsViewProtocol,
         interactor: SetsInteractorProtocol,
         database: DatabaseProtocol?,
         navigator: SetsListNavigator) {
        self.view = view
        self.interactor = interactor
        self.database = database
        self.navigator = navigator
    }

    func viewDidLoad() {
        view?.startAnimating()
        view?.setupNavigationItem()
        retrieveSets()
    }

    func retrieveSets() {
        Task { [weak self] in
            do {
                guard let self else { return }

                let setList = try await interactor.retrieveSets()

                await MainActor.run { [weak self] in
                    self?.view?.updateSetList(setList)
                    self?.view?.stopAnimating()
                    self?.view?.endRefreshControl()
                }
            } catch {
                await MainActor.run { [weak self] in
                    ToastMessages.showNetworkErrorMessage()
                    LoggerManager.shared.log(event: .setsList, parameters: ["error": error.localizedDescription])
                    self?.view?.stopAnimating()
                    self?.view?.endRefreshControl()
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
