//
//  SwappableScrollView.swift
//  SwipeToDeleteCollectionView
//
//  Created by Reynaldo Aguilar on 8/16/18.
//  Copyright © 2018 Reynaldo Aguilar. All rights reserved.
//

import Foundation
import UIKit

class SwappableScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Since the scroll view covers all the surface of the cell, by default it will process all
        // the touches, which causes the cell selection to stop working.
        // We want to ignore touch events that are on the scroll view itself so that the cell
        // selection continues working. Because of this, if the hitted view is the scroll view then
        // we ignore it returning `nil`. However, when we are displaying the _Delete_ button, we
        // want to stop ignoring touches in the scroll so that if the user touches it then the
        // scroll view will scroll to its original position. This is just for simulating the
        // behavior of the `UITableView`, if that behavior isn't need then just remove that part
        // of the condition.
        let result = super.hitTest(point, with: event)
        
        let scrollIsOpened = contentOffset.x > 0
        
        if result != self || scrollIsOpened {
            return result
        }
        else {
            return nil
        }
    }
}
