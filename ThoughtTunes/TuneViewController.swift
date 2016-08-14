//
//  TuneViewController.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/5/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import UIKit

class TuneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //TODO: for local data, use LocalDataHandler(); for external url, use DataHandler()
    var dataHandler: LocalDataHandler? = LocalDataHandler()
    
    @IBOutlet var tuneTableView: UITableView!
    var refreshControl = UIRefreshControl()
    internal var tuneIDQueries: String?
    var localNotifier = NSNotificationCenter.defaultCenter()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        updateDataFromTuneIDQueries()
        
        tuneTableView.estimatedRowHeight = 500
        tuneTableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.attributedTitle = NSAttributedString(string: CustomerFacingText.refreshControl)
        refreshControl.addTarget(self, action: #selector(updateDataFromTuneIDQueries), forControlEvents: .ValueChanged)
        tuneTableView.addSubview(refreshControl)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        localNotifier.addObserver(self, selector: #selector(reloadTableView), name: Notifications.tuneDataListSet, object: dataHandler)
    }
    
    deinit {
        localNotifier.removeObserver(self)
    }
    
    
    
    //MARK: TableView Handling
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataList = dataHandler?.tuneDataList {
            return dataList.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let privateQueue = dispatch_queue_create("com.floydhillcode.queue", DISPATCH_QUEUE_CONCURRENT)
        let cell = tableView.dequeueReusableCellWithIdentifier(VCCellNames.tuneCell, forIndexPath: indexPath) as! TuneCell
        
        if let dataList = dataHandler?.tuneDataList {
            dispatch_async(privateQueue) {
                dispatch_async(dispatch_get_main_queue()) {
                    cell.tuneName.text = dataList[indexPath.row].name
                    cell.tuneDescription.text = dataList[indexPath.row].tuneDescription
                }
                
                if let typeFromDataList = dataList[indexPath.row].type {
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.tuneType.text = CellTextPrefixes.type + typeFromDataList
                    }
                }
                
                if let idFromDataList = dataList[indexPath.row].id{
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.tuneID.text = CellTextPrefixes.songID + idFromDataList
                    }
                }
                
                if let coverUrlString = dataList[indexPath.row].cover_url {
                    if let url  = NSURL(string: coverUrlString),
                        data = NSData(contentsOfURL: url)
                    {
                        dispatch_async(dispatch_get_main_queue()) {
                            cell.tuneArtImage.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func updateDataFromTuneIDQueries() {
        if let tuneIDQueries = tuneIDQueries {
            dataHandler?.updateData(.Tune, ifCategoryThenTagType: nil, ifTuneThenQueryString: tuneIDQueries)
        }
    }
    
    func reloadTableView() {
        tuneTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
    
}
