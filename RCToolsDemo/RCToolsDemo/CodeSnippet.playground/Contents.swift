//: Playground - noun: a place where people can play

import UIKit

/// RTLabel
let label = UILabel(frame: <#T##CGRect#>)
label.font = <#font#>
label.textColor = <#color#>
label.text = <#text#>
label.sizeToFit()

<#superView#>.addSubview(label)

/// RTButton
let button = UIButton(frame: <#T##CGRect#>)
button.setTitle(<#T##title: String?##String?#>, forState: <#T##UIControlState#>)
button.setTitleColor(<#T##color: UIColor?##UIColor?#>, forState: <#T##UIControlState#>)
button.addTarget(<#T##target: AnyObject?##AnyObject?#>, action: <#T##Selector#>, forControlEvents: <#T##UIControlEvents#>)
button.sizeToFit()

<#superView#>.addSubview(button)

func <#buttonHandler#> (sender: UIButton) {
    <#code#>
}

/// RTTable
let table = UITableView(frame: <#T##CGRect#>)
table.delegate = <#object#>
table.dataSource = <#object#>
table.registerClass(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)

<#superView#>.addSubview(table)

extension <#className#> : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        <#code#>
    }
}


/// RTCollection
let layout = UICollectionViewFlowLayout()
layout.minimumInteritemSpacing = 0
layout.minimumLineSpacing = 0
layout.itemSize = <#itemSize#>

let collection = UICollectionView(frame: <#T##CGRect#>, collectionViewLayout: layout)
collection.delegate = <#object#>
collection.dataSource = <#object#>
collection.registerClass(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)

extension <#className#>: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        <#code#>
    }
}


/// RTImage
let image = UIImageView(image: <#T##UIImage?#>)

