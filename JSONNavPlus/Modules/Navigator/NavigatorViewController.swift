//
//  NavigatorViewController.swift
//  JSONNavPlus
//
//  Created by Roman on 05.01.2018.
//  Copyright © 2018 Roman Gishtimulat. All rights reserved.
//

import UIKit

protocol NavigatorViewProtocol: class {
    func displayFolderContentWith(title: String?)
}

class NavigatorViewController: UIViewController {
    var configurator = NavigatorConfigurator()
    var presenter: NavigatorPresenterProtocol!
    
    @IBOutlet weak var navigatorTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(navigatorViewController: self)
        presenter.prepareContentForCurrentFolder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
}

extension NavigatorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelect(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfDisplayElements
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Globals.Cells.navigatorCell, for: indexPath) as! NavigatorCell
        presenter.configure(cell: cell, row: indexPath.row)
        return cell
    }
}

extension NavigatorViewController: NavigatorViewProtocol {
    func displayFolderContentWith(title: String?) {
        DispatchQueue.main.async {
            self.title = title
            self.navigatorTableView.reloadData()
        }
    }
}
