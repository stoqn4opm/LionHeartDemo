//
//  OpenImageTransition.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 31.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

protocol OpenImageAnimatable {
    var centeredView: UIView? { get }
    var fadeOutViews: [UIView]? { get }
}

class OpenImageAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    fileprivate let duration: TimeInterval = 3
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: .from)?.subviews.first as? UICollectionView else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let fromAnimatable = transitionContext.viewController(forKey: .from) as? OpenImageAnimatable else { return }
        guard let viewToBeCentered = fromAnimatable.centeredView else { return }
        
        transitionContext.containerView.addSubview(toView)
        toView.alpha = 0
        
        let originalCenter = viewToBeCentered.center
        
        let screenBounds = UIScreen.main.bounds
        let screenCenter = CGPoint(x: (fromView.contentOffset.x) + screenBounds.size.width / 2,
                                   y: (fromView.contentOffset.y) + screenBounds.size.height / 2)
        
        let durationOfStep = 1 / 4 * duration
        
        let animator1 = UIViewPropertyAnimator(duration: durationOfStep, dampingRatio: 1) { fromAnimatable.fadeOutViews?.forEach({ (view) in view.alpha = 0 }) }
        animator1.addCompletion { _ in
            let animator2 = UIViewPropertyAnimator(duration: durationOfStep, dampingRatio: 0.7) { viewToBeCentered.center = screenCenter }
            animator2.addCompletion { _ in
                let animator3 = UIViewPropertyAnimator(duration: durationOfStep, dampingRatio: 1) { viewToBeCentered.alpha = 0 }
                animator3.addCompletion { _ in
                    let animator4 = UIViewPropertyAnimator(duration: durationOfStep, dampingRatio: 1) { toView.alpha = 1 }
                    animator4.addCompletion { _ in
                        fromAnimatable.fadeOutViews?.forEach({ (view) in view.alpha = 1 })
                        viewToBeCentered.center = originalCenter
                        viewToBeCentered.alpha = 1
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    }
                    animator4.startAnimation()
                }
                animator3.startAnimation()
            }
            animator2.startAnimation()
        }
        animator1.startAnimation()
    }
}
