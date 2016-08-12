//
//  TagViewController.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/5/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//



import UIKit

class TagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tagTableView: UITableView!
    var refreshControl = UIRefreshControl()
    var dataHandler: LocalDataHandler? = LocalDataHandler()
    var localNotifier = NSNotificationCenter.defaultCenter()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataHandler?.updateData(.Tag, ifCategoryThenTagType: nil, ifTuneThenQueryString: nil)
        
        refreshControl.attributedTitle = NSAttributedString(string: CustomerFacingText.refreshControl)
        refreshControl.addTarget(self, action: #selector(updateData), forControlEvents: .ValueChanged)
        tagTableView.addSubview(refreshControl)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        localNotifier.addObserver(self, selector: #selector(reloadTableView), name: Notifications.tagDataListSet, object: dataHandler)
    }
    
    
    deinit {
        localNotifier.removeObserver(self)
    }
    
    
    
    //MARK: TableView Handling
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataList = dataHandler?.tagDataList {
            return dataList.count
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(VCCellNames.tagCell, forIndexPath: indexPath) as! TagCell
        
        if let dataList = dataHandler?.tagDataList {
            cell.tagName.text = dataList[indexPath.row].title
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let dataList = dataHandler?.tagDataList {
            
            let storyboard = UIStoryboard(name: VCNames.categoryViewController, bundle: nil)
            
            if let vc = storyboard.instantiateViewControllerWithIdentifier(VCNames.categoryViewController) as? CategoryViewController {
                let tagTitle = dataList[indexPath.row].title
                
                dispatch_async(dispatch_get_main_queue()) {
                    if tagTitle == TagType.Artists.rawValue {
                        vc.tagChosen = TagType.Artists
                        self.showViewController(vc, sender: self)
                    } else if tagTitle == TagType.Albums.rawValue {
                        vc.tagChosen = TagType.Albums
                        self.showViewController(vc, sender: self)
                    } else if tagTitle == TagType.Genre.rawValue {
                        vc.tagChosen = TagType.Genre
                        self.showViewController(vc, sender: self)
                    }
                }
            }
        }
    }
    
    
    func updateData() {
        dataHandler?.updateData(.Tag, ifCategoryThenTagType: nil, ifTuneThenQueryString: nil)
    }
    
    
    func reloadTableView() {
        self.tagTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
}
