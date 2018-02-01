//
//  EditPhotoViewController.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 30.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

enum AdjustmentSliderTags: Int {
    case first = 1
    case second = 2
    case third = 3
}

//MARK: - ViewController's Life Cycle

class EditPhotoViewController: UIViewController {

    @IBOutlet weak var editContainerBottomConstaint: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var editContainer: UIVisualEffectView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var adjustmentLabel1: UILabel!
    @IBOutlet weak var adjustmentLabel2: UILabel!
    @IBOutlet weak var adjustmentLabel3: UILabel!
    @IBOutlet weak var adjustmentSlider1: UISlider!
    @IBOutlet weak var adjustmentSlider2: UISlider!
    @IBOutlet weak var adjustmentSlider3: UISlider!
    var viewModel: EditPhotoViewModel?
    
    fileprivate var isInEditMode: Bool? {
        didSet {
            editContainerBottomConstaint.constant = isInEditMode == true ? -60 : -200
            view.setNeedsUpdateConstraints()
            editButton.title = isInEditMode == true ? "Cancel".localized : "Edit".localized
            
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .allowUserInteraction, animations: {[weak self] in
                
                self?.view.layoutIfNeeded()
                self?.editContainer.isUserInteractionEnabled = self?.isInEditMode == true

            }, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        prepareViewModel()
        isInEditMode = false
        editContainer.layer.cornerRadius = 9
        editContainer.clipsToBounds = true
        updateAllAdjustmentLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = viewModel?.photo.title
    }
    
    fileprivate func prepareViewModel() {
        viewModel?.notificationLabels = [adjustmentLabel1, adjustmentLabel2, adjustmentLabel3]
        viewModel?.imageView = imageView
        viewModel?.saveButton = saveButton
    }
}

//MARK: - User Actions

extension EditPhotoViewController {
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let image = viewModel?.photo.image else { return }
        guard let title = viewModel?.photo.title else { return }
        isInEditMode = false
        
        let shareController = UIActivityViewController(activityItems: [image, title], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
        if isInEditMode == true {
            if viewModel?.hasPerformedChanges == true {
                let alert = UIAlertController(title: "Are you sure that you want to discard your changes ?".localized,
                                              message: "The image will be returned to its original appearance.".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes".localized, style: .destructive, handler: { [weak self] _ in
                    self?.isInEditMode = false
                    self?.viewModel?.cancel()
                    self?.resetSliders()
                }))
                alert.addAction(UIAlertAction(title: "No".localized, style: .cancel, handler: nil ))
                present(alert, animated: true, completion: nil)
            } else {
                isInEditMode = false
                viewModel?.cancel()
            }
        } else {
            viewModel?.cancel()
            isInEditMode = true
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure that you want to save your changes ?".localized,
                                      message: "The image will be updated to match your adjustments.".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .destructive, handler: { [weak self] _ in
            self?.resetSliders()
            self?.viewModel?.save()
            self?.isInEditMode = false
        }))
        alert.addAction(UIAlertAction(title: "No".localized, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - User Edit Actions

extension EditPhotoViewController {
    
    @IBAction func adjustmentSlider1ValueChanged(_ sender: UISlider) {
        viewModel?.applySepiaToPhoto(sender.value)
    }
    
    @IBAction func adjustmentSlider2ValueChanged(_ sender: UISlider) {
        viewModel?.applyBrightnessToPhoto(sender.value)
    }
    
    @IBAction func adjustmentSlider3ValueChanged(_ sender: UISlider) {
        viewModel?.applySaturationToPhoto(sender.value)
    }

    @IBAction func adjustmentSlider1SnapToMiddle(_ sender: UISlider) {
        if 0.45 < sender.value && sender.value < 0.55 {
            sender.setValue(0.5, animated: true)
            guard let sliderTag = AdjustmentSliderTags(rawValue: sender.tag) else { return }
            switch sliderTag {
            case AdjustmentSliderTags.first:  viewModel?.applySepiaToPhoto(sender.value)
            case AdjustmentSliderTags.second: viewModel?.applyBrightnessToPhoto(sender.value)
            case AdjustmentSliderTags.third:  viewModel?.applySaturationToPhoto(sender.value)
            }
        }
    }
}

//MARK: - Helper Functions

extension EditPhotoViewController {
    
    func resetSliders() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
            self?.adjustmentSlider1.setValue(0, animated: true)
            self?.adjustmentSlider2.setValue(0, animated: true)
            self?.adjustmentSlider3.setValue(0, animated: true)
            self?.updateAllAdjustmentLabels()
        })
    }
    
    func updateAllAdjustmentLabels() {
        adjustmentLabel1.text = String(format: "%.1f", adjustmentSlider1.value)
        adjustmentLabel2.text = String(format: "%.1f", adjustmentSlider2.value)
        adjustmentLabel3.text = String(format: "%.1f", adjustmentSlider3.value)
    }
}
