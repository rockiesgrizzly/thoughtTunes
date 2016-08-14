//
//  TagViewController.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/5/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//



import UIKit

class TagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //TODO: for local data, use LocalDataHandler(); for external url, use DataHandler()
    var dataHandler: LocalDataHandler? = LocalDataHandler()
    
    @IBOutlet var tagTableView: UITableView!
    var refreshControl = UIRefreshControl()
    var localNotifier = NSNotificationCenter.defaultCenter()
    let privateQueue = dispatch_queue_create("com.floydhillcode.queue", DISPATCH_QUEUE_CONCURRENT)
    
    
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
        
        dispatch_async(privateQueue) {
            if let dataList = self.dataHandler?.tagDataList {
                dispatch_async(dispatch_get_main_queue()) {
                    cell.tagName.text = dataList[indexPath.row].title
                }
            }
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
                    } else if tagTitle == TagType.Albums.rawValue {
                        vc.tagChosen = TagType.Albums
                    } else if tagTitle == TagType.Genre.rawValue {
                        vc.tagChosen = TagType.Genre
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
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
