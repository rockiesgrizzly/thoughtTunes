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
    
    lazy var dataList: [String: String] = {
        return ["name": "Angel of Harlem", "type": "Basic", "description": "54321", "cover_url": "http://image.jpg", "song_id": "54321"]
    }()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    
    //MARK: TableView Handling
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dataList.count
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(VCCellNames.tuneCell, forIndexPath: indexPath) as! TuneCell
        
        //cell.tuneArtImage.text = "http://web.jpg"
        cell.tuneName.text = dataList["name"]
        cell.tuneType.text = dataList["type"]
        //TODO: figure out if ID should be shown
        cell.tuneID.text = "54321"
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    


}