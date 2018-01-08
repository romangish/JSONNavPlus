//
//  NavigatorPresenter.swift
//  JSONNavPlus
//
//  Created by Roman on 05.01.2018.
//  Copyright © 2018 Roman Gishtimulat. All rights reserved.
//

import UIKit

enum DisplayElementType: Int {
    case up
    case folder
    case file
}

struct DisplayFolderContentElement {
    var name: String
    var type: DisplayElementType
    var icon: String
}

protocol NavigatorPresenterProtocol {
    var numberOfDisplayElements: Int { get }
    var router: NavigatorRouterProtocol { get }
    func configure(cell: NavigatorCell, row: Int)
    func prepareContentForCurrentFolder()
    func didSelect(row: Int)
}

class NavigatorPresenter: NavigatorPresenterProtocol {
    private weak var view: NavigatorViewProtocol?
    private var dataSource: dataSourceProtocol?
    var router: NavigatorRouterProtocol
    
    private var pathToCurrentFolder = [String]()
    private var displayElements = [DisplayFolderContentElement]()
    
    var numberOfDisplayElements: Int {
        return displayElements.count
    }
    
    init(view: NavigatorViewProtocol,
         router: NavigatorRouterProtocol,
         dataSource: dataSourceProtocol) {
        self.view = view
        self.router = router
        self.dataSource = dataSource
    }
    
    func configure(cell: NavigatorCell, row: Int) {
        cell.nameLabel.text = displayElements[row].name
        cell.iconImageView.image = UIImage(named: displayElements[row].icon) ?? UIImage(named: Globals.Icons.unknown)
    }
    
    func prepareContentForCurrentFolder() {
        var result = [DisplayFolderContentElement]()
        defer {
            displayElements = result.sorted(by: {$1.type.rawValue > $0.type.rawValue})
            view?.displayFolderContentWith(title: pathToCurrentFolder.last)
        }
        if pathToCurrentFolder.count > 0 {
            result.append(DisplayFolderContentElement(name: "..", type: .up, icon: Globals.Icons.up))
        }
        guard let folderContent = dataSource?.getFolderContentFor(path: pathToCurrentFolder) else { return }
        for (name, element) in folderContent {
            if let fileSystemElementType = element.type {
                var displayIcon: String!
                var displayElementType: DisplayElementType!
                switch fileSystemElementType {
                case .file:
                    displayIcon = element.fileIcon ?? Globals.Icons.unknown
                    displayElementType = .file
                case .folder:
                    displayIcon = Globals.Icons.folder
                    displayElementType = .folder
                }
                result.append(DisplayFolderContentElement(name: name, type: displayElementType, icon: displayIcon))
            }
        }
    }

    func moveUpOneDirectory() {
        pathToCurrentFolder.removeLast(1)
        prepareContentForCurrentFolder()
    }
    
    func putIn(subdirectory: String) {
        pathToCurrentFolder.append(subdirectory)
        prepareContentForCurrentFolder()
    }
    
    func didSelect(row: Int) {
        let element = displayElements[row]
        switch element.type {
        case .up:
            moveUpOneDirectory()
        case .folder:
            putIn(subdirectory: element.name)
        case .file:
            let fileContent = dataSource?.getFileContent(path: pathToCurrentFolder, filename: element.name)
            router.presentFileContentView(fileName: element.name, fileContent: fileContent)
        }
    }
}
