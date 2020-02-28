//
//  TagViewController.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/5/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//



import UIKit

class TagViewController: UIViewController {
    
    //TODO: for local data, use LocalDataHandler(); for external url, use DataHandler()
    var dataHandler: LocalDataHandler? = LocalDataHandler()
    
    @IBOutlet var tagTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()
    var localNotifier = NotificationCenter.default
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataHandler?.updateData(modelType: .Tag, ifCategoryThenTagType: nil, ifTuneThenQueryString: nil)
        
        refreshControl.attributedTitle = NSAttributedString(string: CustomerFacingText.refreshControl)
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        tagTableView.addSubview(refreshControl)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        localNotifier.addObserver(self,
                                  selector: #selector(reloadTableView),
                                  name: NSNotification.Name(rawValue: Notifications.tagDataListSet),
                                  object: dataHandler)
    }
    
    
    deinit {
        localNotifier.removeObserver(self)
    }
    
    
    @objc func updateData() {
        dataHandler?.updateData(modelType: .Tag, ifCategoryThenTagType: nil, ifTuneThenQueryString: nil)
    }
    
    
    @objc func reloadTableView() {
        activityIndicator.stopAnimating()
        tagTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    
}

//MARK: - TableView
extension TagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCCellNames.tagCell, for: indexPath) as! TagCell
        
        if let dataList = dataHandler?.tagDataList {
            cell.tagName.text = dataList[indexPath.row].title
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataList = dataHandler?.tagDataList {
            return dataList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dataList = dataHandler?.tagDataList {
            
            let storyboard = UIStoryboard(name: VCNames.categoryViewController, bundle: nil)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: VCNames.categoryViewController) as? CategoryViewController {
                let tagTitle = dataList[indexPath.row].title
                
                if tagTitle == TagType.Artists.rawValue {
                    vc.tagChosen = TagType.Artists
                } else if tagTitle == TagType.Albums.rawValue {
                    vc.tagChosen = TagType.Albums
                } else if tagTitle == TagType.Genre.rawValue {
                    vc.tagChosen = TagType.Genre
                }
                
                show(vc, sender: self)
            }
        }
    }
}
