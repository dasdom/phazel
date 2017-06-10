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
        print("Number of rows: \(dataArray.count)")
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        
        let post = dataArray[indexPath.row]
        delegate?.configure(cell, for: post)
        
        return cell
    }
    
    func add(posts: [Object]) {
        
        contentSizeBefore = tableView.contentSize
        
        dataArray = posts + dataArray
        
        tableView.reloadData()
        
        let contentSizeAfter = tableView.contentSize
        let currentContentOffset = tableView.contentOffset
        
        if let contentSizeBefore = contentSizeBefore {
            let newOffsetY = currentContentOffset.y + contentSizeAfter.height - contentSizeBefore.height
            print("newOffsetY: \(newOffsetY)")
            tableView.setContentOffset(CGPoint(x: 0, y: newOffsetY), animated: false)
        }

        let maxNumberOfShownPosts = 1000
        if dataArray.count > maxNumberOfShownPosts {
            dataArray.removeLast(dataArray.count - maxNumberOfShownPosts)
        }
        
        tableView.reloadData()
        
    }
    
}
