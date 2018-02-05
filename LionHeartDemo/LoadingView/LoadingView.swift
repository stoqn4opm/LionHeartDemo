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
    
    static func show() {
        guard let window = UIApplication.shared.windows.first else {printInfo("[LoadingView] show() failed"); return }
        let nib = UINib(nibName: "LoadingView", bundle: nil)
        guard let loadingView = nib.instantiate(withOwner: window, options: nil).first as? LoadingView else { printInfo("[LoadingView] show() failed"); return }
        LoadingView.presentedLoadingView = loadingView
        window.addSubview(loadingView)
        
        let width = NSLayoutConstraint(item: loadingView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90)
        let height = NSLayoutConstraint(item: loadingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90)
        loadingView.addConstraints([width, height])
        
        let centerX = NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: window, attribute: .centerY, multiplier: 1, constant: 0)
        window.addConstraints([centerX, centerY])
    }
    
    static func hide() {
        LoadingView.presentedLoadingView?.removeFromSuperview()
        LoadingView.presentedLoadingView = nil
    }
}

//MARK: - Class Definition

class LoadingView: UIView {
    fileprivate static var presentedLoadingView: LoadingView?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var backgroundView: UIVisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spinner.startAnimating()
        label.text = "Loading...".localized
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 9
        backgroundView.layer.allowsEdgeAntialiasing = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
}
