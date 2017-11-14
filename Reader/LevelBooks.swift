//
//  LevelBooks.swift
//  Reader
//
//  Created by мак on 14.07.17.
//  Copyright © 2017 мак. All rights reserved.
//

import UIKit
import SWRevealViewController
import Parse
import FolioReaderKit

class LevelBooks: UITableViewController {
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    var level: String = ""
    var books: [Book] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        if self.revealViewController() != nil {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        requestBooks()
    }
    
    func requestBooks() {
        let query = PFQuery(className: "Book")
        query.whereKey("level", equalTo: self.level)
        query.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                if let returnedobjects = objects {
                    PFObject.pinAll(inBackground: returnedobjects)
                    for object in returnedobjects {
                        var image = UIImage()
                        let userImageFile = object["image"] as! PFFile
                        
                        if let imageData = try? userImageFile.getData() {
                            image = UIImage(data:imageData)!
                            
                            let book = Book(name: object["name"] as! String, image: image, level: object["level"] as! String, describe: object["describe"] as! String, bookFile: object["bookFile"] as! PFFile)
                            self.books.append(book)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func open(book: Book) {
        let config = FolioReaderConfig()
        let folioReader = FolioReader()
        book.bookFile.getPathInBackground(block: { (path, error) in
            folioReader.presentReader(parentViewController: self, withEpubPath: path!, andConfig: config)
        })
    }

    func download(book: Book) {
        if book.bookFile.isDataAvailable {
            open(book: book)
        } else {
            book.bookFile.getDataInBackground({ [unowned self] (data, error) in
                self.tableView.reloadData()
                }, progressBlock: { (progress) in
                    print(progress)
            })
            
        }
    }
}

extension LevelBooks {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LevelBooksCell
        
        let book = books[indexPath.row]
        
        cell.textBook.text = book.describe
        cell.imageBook.image = book.image
        cell.downloadBlock = { [weak self] in
            self?.download(book: book)
        }
        
        if book.bookFile.isDataAvailable {
            cell.button.setTitle("Open", for: .normal)
        } else {
            cell.button.setTitle("Download", for: .normal)
        }
        
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
}
