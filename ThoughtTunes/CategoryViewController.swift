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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tagChosen: TagType?
    var refreshControl = UIRefreshControl()
    var localNotifier = NSNotificationCenter.defaultCenter()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDataFromTagType()
        
        //TODO: set up refresh elsewhere
        refreshControl.attributedTitle = NSAttributedString(string: CustomerFacingText.refreshControl)
        refreshControl.addTarget(self, action: #selector(updateDataFromTagType), forControlEvents: .ValueChanged)
        catTableView.addSubview(refreshControl)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
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
        
        if let dataList = dataHandler?.categoryDataList {
            cell.categoryName.text = dataList[indexPath.row].name
            activityIndicator.stopAnimating()
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
                
                vc.tuneIDQueries = tuneIDs
                showViewController(vc, sender: self)
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
        catTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
    
}
