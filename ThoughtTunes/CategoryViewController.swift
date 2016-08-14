//
//  CategoryViewController.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/5/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //TODO: for local data, use LocalDataHandler(); for external url, use DataHandler()
    var dataHandler: LocalDataHandler? = LocalDataHandler()
    
    @IBOutlet var catTableView: UITableView!
    internal var tagChosen: TagType?
    var refreshControl = UIRefreshControl()
    var localNotifier = NSNotificationCenter.defaultCenter()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDataFromTagType()
        
        refreshControl.attributedTitle = NSAttributedString(string: CustomerFacingText.refreshControl)
        refreshControl.addTarget(self, action: #selector(updateDataFromTagType), forControlEvents: .ValueChanged)
        catTableView.addSubview(refreshControl)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        localNotifier.addObserver(self, selector: #selector(reloadTableView), name: Notifications.categoryDataListSet, object: dataHandler)
    }
    
    deinit {
        localNotifier.removeObserver(self)
    }


    //MARK: TableView Handling
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataList = dataHandler?.categoryDataList {
            return dataList.count
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(VCCellNames.categoryCell, forIndexPath: indexPath) as! CategoryCell
        
        let privateQueue = dispatch_queue_create("com.floydhillcode.queue", DISPATCH_QUEUE_CONCURRENT)
        
        dispatch_async(privateQueue) {
            if let dataList = self.dataHandler?.categoryDataList {
                dispatch_async(dispatch_get_main_queue()) {
                    cell.categoryName.text = dataList[indexPath.row].name
                }
            }
        }
        return cell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let dataList = dataHandler?.categoryDataList {
            
            let storyboard = UIStoryboard(name: VCNames.tuneViewController, bundle: nil)
            
            if let vc = storyboard.instantiateViewControllerWithIdentifier(VCNames.tuneViewController) as? TuneViewController {
                let tuneIDs = dataList[indexPath.row].song_ids
                
                dispatch_async(dispatch_get_main_queue()) {
                    vc.tuneIDQueries = tuneIDs
                    self.showViewController(vc, sender: self)
                }
            }
        }
    }
    
    func updateDataFromTagType() {
        if let tagChosen = tagChosen {
            switch tagChosen {
            case .Artists:
                dataHandler?.updateData(.Category, ifCategoryThenTagType: .Artists, ifTuneThenQueryString:  nil)
            case .Albums:
                dataHandler?.updateData(.Category, ifCategoryThenTagType: .Albums, ifTuneThenQueryString: nil)
            case .Genre:
                dataHandler?.updateData(.Category, ifCategoryThenTagType: .Genre, ifTuneThenQueryString: nil)
            }
        }
    }
    
    
    @IBAction func updateButtonTapped(sender: AnyObject) {
        updateDataFromTagType()
    }
    
    
    func reloadTableView() {
        self.catTableView.reloadData()
        refreshControl.endRefreshing()
    }
    



}
