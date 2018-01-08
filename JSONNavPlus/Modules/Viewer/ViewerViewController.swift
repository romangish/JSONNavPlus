//
//  ViewerViewController.swift
//  JSONNavPlus
//
//  Created by Roman on 08.01.2018.
//  Copyright © 2018 Roman Gishtimulat. All rights reserved.
//

import UIKit

class ViewerViewController: UIViewController {
    @IBOutlet weak var viewerTextView: UITextView!
    var fileContent: String?
    var fileName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewerTextView.text = fileContent
        self.title = fileName
    }
}
