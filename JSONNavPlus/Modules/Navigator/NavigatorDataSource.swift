//
//  NavigatorDataSource.swift
//  JSONNavPlus
//
//  Created by Roman on 08.01.2018.
//  Copyright © 2018 Roman Gishtimulat. All rights reserved.
//

import Foundation
import HandyJSON

typealias FolderContent = Dictionary<String,FileSystemElement>

enum FileSystemElementType: String, HandyJSONEnum {
    case folder
    case file
}

class FileSystemElement: HandyJSON {
    var type: FileSystemElementType?
    var folderContent: FolderContent?
    var fileIcon: String?
    var fileContent: String?
    required init() {}
}

protocol dataSourceProtocol {
    func getFolderContentFor(path: [String]) -> FolderContent?
    func getFileContent(path: [String], filename: String) -> String?
}

final class NavigatorDataSource: dataSourceProtocol {
    private var fileSystemStructure: FileSystemElement?
    
    init() {
        self.fileSystemStructure = loadFileSystemStructure()
    }
    
    private func loadFileSystemStructure() -> FileSystemElement? {
        guard let path = Bundle.main.path(forResource: Globals.DataSource.filename, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let jsonString = String(data: data, encoding: String.Encoding.utf8),
            let fileSystemStructure = FileSystemElement.deserialize(from: jsonString) else { return nil }
        return fileSystemStructure
    }
    
    func getFolderContentFor(path: [String]) -> FolderContent? {
        var folder = self.fileSystemStructure
        path.forEach({folder = folder?.folderContent?[$0]})
        return folder?.folderContent
    }
    
    func getFileContent(path: [String], filename: String) -> String? {
        return getFolderContentFor(path: path)?[filename]?.fileContent
    }
}
