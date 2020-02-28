//
//  TuneViewController.swift
//  ThoughtTunes
//
//  Created by Josh MacDonald on 8/5/16.
//  Copyright © 2016 floydhillcode. All rights reserved.
//

import UIKit

class TuneViewController: UIViewController {
    
    //TODO: for local data, use LocalDataHandler(); for external url, use DataHandler()
    var dataHandler: LocalDataHandler? = LocalDataHandler()
    
    @IBOutlet var tuneTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()
    var tuneIDQueries: String?
    var localNotifier = NotificationCenter.default
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataFromTuneIDQueries()
        
       tuneTableView.estimatedRowHeight = 500
        tuneTableView.rowHeight = UITableView.automaticDimension
        tuneTableView.layoutIfNeeded()
        
        refreshControl.attributedTitle = NSAttributedString(string: CustomerFacingText.refreshControl)
        refreshControl.addTarget(self, action: #selector(updateDataFromTuneIDQueries), for: .valueChanged)
        tuneTableView.addSubview(refreshControl)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localNotifier.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: Notifications.tuneDataListSet), object: dataHandler)
    }
    
    
    deinit {
        localNotifier.removeObserver(self)
    }
    
    @objc func updateDataFromTuneIDQueries() {
        if let tuneIDQueries = tuneIDQueries {
            dataHandler?.updateData(modelType: .Tune, ifCategoryThenTagType: nil, ifTuneThenQueryString: tuneIDQueries)
        }
    }
    
    
    @objc func reloadTableView() {
        tuneTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}

//MARK: - TableView
extension TuneViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: TableView Handling
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataList = dataHandler?.tuneDataList {
            return dataList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCCellNames.tuneCell, for: indexPath as IndexPath) as! TuneCell
        
        if let dataList = dataHandler?.tuneDataList {
            
            cell.tuneName.text = dataList[indexPath.row].name
            cell.tuneDescription.text = dataList[indexPath.row].tuneDescription
            activityIndicator.stopAnimating()
            
            
            if let typeFromDataList = dataList[indexPath.row].type {
                cell.tuneType.text = CellTextPrefixes.type + typeFromDataList
            }
            
            if let idFromDataList = dataList[indexPath.row].id{
                cell.tuneID.text = CellTextPrefixes.songID + idFromDataList
            }
            
            if let coverUrlString = dataList[indexPath.row].cover_url {
                DispatchQueue.global().async {
                    if let url  = URL(string: coverUrlString),
                        let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
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
    
}
