//
//  BooksTableViewController.swift
//  Reader
//
//  Created by мак on 10.07.17.
//  Copyright © 2017 мак. All rights reserved.
//

import UIKit
import Parse
import FolioReaderKit
import SWRevealViewController


 
class BooksCollectionViewController: UICollectionViewController {
    
    var books: [Book] = []
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    private let leftAndRightPaddings: CGFloat = 40.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    private let heigthAdjustment: CGFloat = 30.0
    
    var activityIndecator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        
        let width = (collectionView!.frame.width - leftAndRightPaddings) / numberOfItemsPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSize(width: width, height: width + heigthAdjustment)
        
        if self.revealViewController() != nil  {
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            navigationItem.rightBarButtonItem = editButtonItem
            self.navigationItem.rightBarButtonItem!.tintColor = UIColor.white
            
            
        }
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        books.removeAll()
        requestBooks()
    }
    
    func requestBooks() {
        let query = PFQuery(className: "Book")
        query.order(byDescending: "createdAt")
        query.fromLocalDatastore()
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
                            if book.bookFile.isDataAvailable {
                                self.books.append(book)
                            }
                        }
                    }
                    
                    self.collectionView?.reloadData()
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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        let book = books[indexPath.item]
        cell.imageView.image = book.image
        cell.deleteButton.layer.cornerRadius = cell.deleteButton.bounds.width / 2.0
        cell.deleteButton.layer.masksToBounds = true
        cell.deleteButton.isHidden = !isEditing
        
        cell.delegate = self
                
        
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? CollectionViewCell {
                    cell.isEditing = editing 
                }
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        open(book: book)
    }
}

extension BooksCollectionViewController : CollectionCellDelegate {
    
    func delete(cell: CollectionViewCell) {
        
        
        self.view.addSubview(activityIndecator)
        activityIndecator.startAnimating()
        
        
        if let indexPath = collectionView?.indexPath(for: cell){
            books[indexPath.item].bookFile.clearCachedDataInBackground().continue({ (task: BFTask) -> Any? in
                DispatchQueue.main.async {
                    self.books.remove(at: indexPath.item)
                    self.collectionView?.deleteItems(at: [indexPath])
                    self.activityIndecator.stopAnimating()
                }
                return nil
            })
        }
        
    }
}








