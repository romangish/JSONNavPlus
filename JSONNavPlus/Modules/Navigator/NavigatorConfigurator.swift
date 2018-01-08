//
//  NavigatorConfigurator.swift
//  JSONNavPlus
//
//  Created by Roman on 08.01.2018.
//  Copyright © 2018 Roman Gishtimulat. All rights reserved.
//

import Foundation

protocol NavigatorConfiguratorProtocol {
    func configure(navigatorViewController: NavigatorViewController)
}

class NavigatorConfigurator: NavigatorConfiguratorProtocol {
    func configure(navigatorViewController: NavigatorViewController) {
        let router = NavigatorRouter(navigatorViewController: navigatorViewController)
        let dataSource = NavigatorDataSource()
        let presenter = NavigatorPresenter(view: navigatorViewController, router: router, dataSource: dataSource)
        navigatorViewController.presenter = presenter
    }
}
