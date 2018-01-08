//
//  NavigatorRouter.swift
//  JSONNavPlus
//
//  Created by Roman on 08.01.2018.
//  Copyright © 2018 Roman Gishtimulat. All rights reserved.
//

import UIKit

protocol ViewRouterProtocol {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

extension ViewRouterProtocol {
    func prepare(for segue: UIStoryboardSegue, sender: Any?) { }
}

protocol NavigatorRouterProtocol: ViewRouterProtocol {
    func presentFileContentView(fileName: String, fileContent: String?)
}

class NavigatorRouter: NavigatorRouterProtocol {
    private weak var navigatorViewController: NavigatorViewController?
    private var fileName: String!
    private var fileContent: String!
    
    init(navigatorViewController: NavigatorViewController) {
        self.navigatorViewController = navigatorViewController
    }
    
    func presentFileContentView(fileName: String, fileContent: String?) {
        self.fileName = fileName
        self.fileContent = fileContent
        navigatorViewController?.performSegue(withIdentifier: Globals.Segues.showFileContent, sender: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewerViewController = segue.destination as? ViewerViewController {
            viewerViewController.fileName = fileName
            viewerViewController.fileContent = fileContent
        }
    }
}
