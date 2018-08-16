//
//  CollectionCell.swift
//  SwipeToDeleteCollectionView
//
//  Created by Reynaldo Aguilar on 8/16/18.
//  Copyright © 2018 Reynaldo Aguilar. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionCellDelegate: class {
    func didPressDeleteButton(_ collectionCell: CollectionCell)
}

class CollectionCell: UICollectionViewCell {
    weak var delegate: CollectionCellDelegate?
    
    private let scrollView = SwappableScrollView()
    private let label = UILabel()
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Delete", for: .normal)
        return button
    }()
    
    var item: String? {
        didSet {
            label.text = item
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(label)
        scrollView.addSubview(button)
        addGestureRecognizer(scrollView.panGestureRecognizer)
        scrollView.delegate = self
        button.addTarget(self, action: #selector(handleDeleteAction(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleOthersCellSwipping(_:)),
            name: .NotificationCellWillStartSwipping,
            object: nil
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        let leftPadding: CGFloat = 16
        label.frame = CGRect(
            x: leftPadding,
            y: 0,
            width: scrollView.bounds.width - leftPadding,
            height: scrollView.bounds.height
        )
        
        button.frame = CGRect(
            x: label.frame.maxX,
            y: 0,
            width: 100,
            height: scrollView.bounds.height
        )
        
        scrollView.contentSize = CGSize(width: button.frame.maxX, height: scrollView.bounds.height)
    }
    
    @objc private func handleDeleteAction(_ sender: Any) {
        delegate?.didPressDeleteButton(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.contentOffset = .zero
    }
}

extension CollectionCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: .NotificationCellWillStartSwipping, object: self)
    }
    
    @objc private func handleOthersCellSwipping(_ notification: Notification) {
        guard let sender = notification.object as? CollectionCell,
            sender != self else { return }
        
        scrollView.setContentOffset(.zero, animated: true)
    }
}

private extension Notification.Name {
    static let NotificationCellWillStartSwipping =
        Notification.Name.init("NotificationCellWillStartSwipping")
}
