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
