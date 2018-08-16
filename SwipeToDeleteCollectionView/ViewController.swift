//
//  ViewController.swift
//  SwipeToDeleteCollectionView
//
//  Created by Reynaldo Aguilar on 8/16/18.
//  Copyright © 2018 Reynaldo Aguilar. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var fontNames: [String]
    
    required init?(coder aDecoder: NSCoder) {
        fontNames = UIFont.familyNames
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(CollectionCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidth = view.bounds.width - layout.sectionInset.left - layout.sectionInset.right
        layout.itemSize = CGSize(width: cellWidth, height: 44)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return fontNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath) as? CollectionCell else {
                fatalError()
        }
        
        cell.item = fontNames[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        let content = fontNames[indexPath.item]
        let vc = DetailsViewController(content: content)
        show(vc, sender: self)
    }
}

extension ViewController: CollectionCellDelegate {
    func didPressDeleteButton(_ collectionCell: CollectionCell) {
        guard let indexPath = collectionView?.indexPath(for: collectionCell) else { return }
        
        fontNames.remove(at: indexPath.item)
        collectionView?.deleteItems(at: [indexPath])
    }
}

class DetailsViewController: UIViewController {
    private let label = UILabel()
    private let content: String
    
    init(content: String) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        label.text = content
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.center = view.center
    }
}
