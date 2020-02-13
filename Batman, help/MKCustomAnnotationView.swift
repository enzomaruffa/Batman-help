//
//  MKCustomAnnotationView.swift
//  BatmanHelp
//
//  Created by Enzo Maruffa Moreira on 13/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit
import MapKit

class MKCustomAnnotationView: MKAnnotationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//    - (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
//    {
//        UIView* hitView = [super hitTest:point withEvent:event];
//        if (hitView != nil)
//        {
//            [self.superview bringSubviewToFront:self];
//        }
//        return hitView;
//    }
//
//    - (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
//    {
//        CGRect rect = self.bounds;
//        BOOL isInside = CGRectContainsPoint(rect, point);
//        if(!isInside)
//        {
//            for (UIView *view in self.subviews)
//            {
//                isInside = CGRectContainsPoint(view.frame, point);
//                if(isInside)
//                    break;
//            }
//        }
//        return isInside;
//    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView != nil {
            self.superview?.bringSubviewToFront(self)
        }
        return hitView
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let isInside = self.frame.contains(point)
        if !isInside {
            for view in self.subviews {
                let isInside = view.frame.contains(point)
                if isInside {
                    break
                }
            }
        }
        return isInside
    }

}
