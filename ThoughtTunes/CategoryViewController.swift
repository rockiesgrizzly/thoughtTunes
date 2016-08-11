//
//  CategoryViewController.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/5/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var catTableView: UITableView!
    internal var tagChosen: TagType?
    var dataHandler: DataHandler? = DataHandler()
    var localNotifier = NSNotificationCenter.defaultCenter()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDataFromTagType()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        localNotifier.addObserver(self, selector: #selector(reloadTableView), name: Notifications.categoryDataListSet, object: dataHandler)
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
        }
        
        return cell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: VCNames.tuneViewController, bundle: nil)
        if let vc = storyboard.instantiateViewControllerWithIdentifier(VCNames.tuneViewController) as? TuneViewController {
            dispatch_async(dispatch_get_main_queue()) {
                self.showViewController(vc, sender: self)
            }
        }
    }
    
    
    func updateDataFromTagType() {
        if let tagChosen = tagChosen {
            switch tagChosen {
            case .Artists:
                dataHandler?.updateData(.Category, ifCategoryThenTagType: .Artists)
            case .Albums:
                dataHandler?.updateData(.Category, ifCategoryThenTagType: .Albums)
            case .Genre:
                dataHandler?.updateData(.Category, ifCategoryThenTagType: .Genre)
            }
        }
    }
    
    
    @IBAction func updateButtonTapped(sender: AnyObject) {
        updateDataFromTagType()
    }
    
    
    func reloadTableView() {
        self.catTableView.reloadData()
    }
    



}
