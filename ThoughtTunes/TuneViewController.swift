//
//  TuneViewController.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/5/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import UIKit

class TuneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tuneTableView: UITableView!
    var dataHandler: DataHandler? = DataHandler()
    var refreshControl = UIRefreshControl()
    internal var tuneIDQueries: String?
    var localNotifier = NSNotificationCenter.defaultCenter()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        updateDataFromTuneIDQueries()
        
        tuneTableView.estimatedRowHeight = 300
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
        let cell = tableView.dequeueReusableCellWithIdentifier(VCCellNames.tuneCell, forIndexPath: indexPath) as! TuneCell
        
        if let dataList = dataHandler?.tuneDataList {
            cell.tuneName.text = dataList[indexPath.row].name
            cell.tuneDescription.text = dataList[indexPath.row].tuneDescription
            
            if let typeFromDataList = dataList[indexPath.row].type {
                cell.tuneType.text = CellTextPrefixes.type + typeFromDataList
            }
            
            if let idFromDataList = dataList[indexPath.row].id{
                cell.tuneID.text = CellTextPrefixes.songID + idFromDataList
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if let coverUrlString = dataList[indexPath.row].cover_url {
                    if let url  = NSURL(string: coverUrlString),
                        data = NSData(contentsOfURL: url)
                    {
                        cell.tuneArtImage.image = UIImage(data: data)
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
