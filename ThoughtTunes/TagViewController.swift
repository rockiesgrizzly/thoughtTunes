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
    @IBOutlet var updateButton: UIBarButtonItem!
    
    
    lazy var dataList: [String] = {
        return ["Artists", "Albums", "Genres"]
    }()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    //MARK: TableView Handling
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(VCCellNames.tagCell, forIndexPath: indexPath) as! TagCell
        
        cell.tagName.text = dataList[indexPath.row]
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: VCNames.categoryViewController, bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(VCNames.categoryViewController)
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.showViewController(vc, sender: self)
        }
        
    }
    
    

    
    

}
