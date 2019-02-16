//
//  LoadingView.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 5.02.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

//MARK: - Show/Hide

extension LoadingView {
    
    /// Shows the `LoadingView`.
    public static func show() {
        guard let window = UIApplication.shared.windows.last else { print("[LoadingView] show() failed"); return }
        let currentBundle = Bundle(for: LoadingView.self)
        let nib = UINib(nibName: "LoadingView", bundle: currentBundle)
        guard let loadingView = nib.instantiate(withOwner: window, options: nil).first as? LoadingView else { print("[LoadingView] show() failed"); return }
        LoadingView.presentedLoadingView = loadingView
        window.addSubview(loadingView)
        
        let width = NSLayoutConstraint(item: loadingView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90)
        let height = NSLayoutConstraint(item: loadingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90)
        loadingView.addConstraints([width, height])
        
        let centerX = NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: window, attribute: .centerY, multiplier: 1, constant: 0)
        window.addConstraints([centerX, centerY])
    }
    
    /// Hides the `LoadingView`
    public static func hide() {
        LoadingView.presentedLoadingView?.removeFromSuperview()
        LoadingView.presentedLoadingView = nil
    }
}

//MARK: - Class Definition

/// Simple loading indicator.
///
/// Use `LoadingView.show()` and `LoadingView.hide()` to interact with it.
public class LoadingView: UIView {
    fileprivate static var presentedLoadingView: LoadingView?
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var backgroundView: UIVisualEffectView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        spinner.startAnimating()
        label.text = "Loading..."
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 9
        backgroundView.layer.allowsEdgeAntialiasing = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
}
