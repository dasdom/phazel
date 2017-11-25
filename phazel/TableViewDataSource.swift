//  Created by dasdom on 25/04/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit

protocol TableViewDataSourceDelegate {
    associatedtype Object: NSObject
    associatedtype Cell: UITableViewCell
    func configure(_ cell: Cell, for object: Object)
}

class TableViewDataSource<Delegate: TableViewDataSourceDelegate>: NSObject, UITableViewDataSource {
    
    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell

    let tableView: UITableView
    let delegate: Delegate?
//    private var correctContentOffset = false
    private var contentSizeBefore: CGSize?
    var dataArray: [Object] = []
    
    init(tableView: UITableView, delegate: Delegate?) {
        
        self.tableView = tableView
        self.delegate = delegate
        
        super.init()
        
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
    }

    func object(at indexPath: IndexPath) -> Object? {
        guard dataArray.count > indexPath.row else { return nil }
        return dataArray[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("Number of rows: \(dataArray.count)")
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        
        let post = dataArray[indexPath.row]
        delegate?.configure(cell, for: post)
        
        return cell
    }
    
    func add(posts: [Object], adjustContentOffset: Bool = true) {
        
        UIView.setAnimationsEnabled(false)

        var contentOffset = tableView.contentOffset.y
//        print(":) before: contentOffset: \(contentOffset)")
        
        tableView.beginUpdates()
        
//        print("posts.count: \(posts.count)")
        dataArray = posts + dataArray
        
        var indexPathsToInsert = [IndexPath]()
        for i in 0..<posts.count {
            let indexPath = IndexPath(item: i, section: 0);
            indexPathsToInsert.append(IndexPath(item: i, section: 0))
            if let cellHeight = tableView.delegate?.tableView?(tableView, heightForRowAt: indexPath) {
//                print("cellHeight (\(indexPath)): \(cellHeight)")
                contentOffset += cellHeight
            }
        }
        // print(":) after: contentOffset: \(contentOffset)")

        if indexPathsToInsert.count > 0 {
            tableView.insertRows(at: indexPathsToInsert, with: .none)
        }
        
        tableView.endUpdates()
        tableView.beginUpdates()
        
        let maxNumberOfShownPosts = 1000
        if dataArray.count > maxNumberOfShownPosts {
            var indexPathsToRemove = [IndexPath]()
            for i in maxNumberOfShownPosts..<dataArray.count {
                indexPathsToRemove.append(IndexPath(row: i, section: 0))
            }
            
            tableView.deleteRows(at: indexPathsToRemove, with: .none)
            
            let numberOfPostsToRemove = dataArray.count - maxNumberOfShownPosts
            dataArray.removeLast(numberOfPostsToRemove)
        }
        
        tableView.endUpdates()
        
        // print("contentOffset: \(contentOffset)")
        if adjustContentOffset, tableView.contentOffset.y < -63, contentOffset < tableView.contentSize.height - tableView.bounds.size.height {
            tableView.contentOffset.y = contentOffset
            // print("contentOffset: \(contentOffset)")
        }
        
        UIView.setAnimationsEnabled(true)
    }
    
}
