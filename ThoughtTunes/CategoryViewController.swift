//
//  CategoryViewController.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/5/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    //TODO: for local data, use LocalDataHandler(); for external url, use DataHandler()
    var dataHandler: LocalDataHandler? = LocalDataHandler()
    
    @IBOutlet var catTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tagChosen: TagType?
    var refreshControl = UIRefreshControl()
    var localNotifier = NotificationCenter.default
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDataFromTagType()
        
        //TODO: set up refresh elsewhere
        refreshControl.attributedTitle = NSAttributedString(string: CustomerFacingText.refreshControl)
        refreshControl.addTarget(self, action: #selector(updateDataFromTagType), for: .valueChanged)
        catTableView.addSubview(refreshControl)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        localNotifier.addObserver(self,
                                  selector: #selector(reloadTableView),
                                  name: NSNotification.Name(rawValue: Notifications.categoryDataListSet),
                                  object: dataHandler)
    }
    
    
    deinit {
        localNotifier.removeObserver(self)
    }
    
    @objc func updateDataFromTagType() {
        if let tagChosen = tagChosen {
            switch tagChosen {
            case .Artists:
                dataHandler?.updateData(modelType: .Category, ifCategoryThenTagType: .Artists, ifTuneThenQueryString:  nil)
            case .Albums:
                dataHandler?.updateData(modelType: .Category, ifCategoryThenTagType: .Albums, ifTuneThenQueryString: nil)
            case .Genre:
                dataHandler?.updateData(modelType: .Category, ifCategoryThenTagType: .Genre, ifTuneThenQueryString: nil)
            }
        }
    }
    
    
    @IBAction func updateButtonTapped(sender: AnyObject) {
        updateDataFromTagType()
    }
    
    
    @objc func reloadTableView() {
        catTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCCellNames.categoryCell, for: indexPath as IndexPath) as! CategoryCell
        
        if let dataList = dataHandler?.categoryDataList {
            cell.categoryName.text = dataList[indexPath.row].name
            activityIndicator.stopAnimating()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataList = dataHandler?.categoryDataList {
            return dataList.count
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let dataList = dataHandler?.categoryDataList {
            
            let storyboard = UIStoryboard(name: VCNames.tuneViewController, bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: VCNames.tuneViewController) as? TuneViewController {
                let tuneIDs = dataList[indexPath.row].song_ids
                
                vc.tuneIDQueries = tuneIDs
                show(vc, sender: self)
            }
        }
    }
    
}
