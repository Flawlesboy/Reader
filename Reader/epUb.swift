//
//  epUb.swift
//  Reader
//
//  Created by zagid on 22.09.17.
//  Copyright © 2017 мак. All rights reserved.
//

import UIKit
import FolioReaderKit

class epUb: UIViewController  {
    
    @IBAction func open(_ sender: Any) {
        let config = FolioReaderConfig()
        let bookPath = Bundle.main.path(forResource: "book", ofType: "epub")
        let folioReader = FolioReader()
        folioReader.presentReader(parentViewController: self, withEpubPath: bookPath!, andConfig: config)
        
        print("asd")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
