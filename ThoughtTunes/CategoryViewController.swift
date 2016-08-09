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
    
    lazy var dataList: [String] = {
        return ["Arcade Fire", "The Beatles", "Coldplay", "dc Talk", "Elton John", "U2"]
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("categoryViewLoaded")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    //MARK: TableView Handling
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(VCCellNames.categoryCell, forIndexPath: indexPath) as! CategoryCell
        
        cell.categoryName.text = dataList[indexPath.row]
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: VCNames.tuneViewController, bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(VCNames.tuneViewController)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.showViewController(vc, sender: self)
        }
    }
    
    



}
