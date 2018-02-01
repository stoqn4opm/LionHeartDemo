//
//  EditPhotoViewModel.swift
//  LionHeartDemo
//
//  Created by Stoyan Stoyanov on 30.01.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

class EditPhotoViewModel {
    
    fileprivate(set) var photo: Photo
    fileprivate var editedPhoto: UIImage?
    
    fileprivate var firstEditSourceTag: AdjustmentSliderTags?
    
    var imageView: UIImageView? {
        didSet { imageView?.image = photo.image }
    }
    
    var notificationLabels: [UILabel]?
    var saveButton: UIBarButtonItem? {
        didSet { saveButton?.isEnabled = hasPerformedChanges }
    }
    
    init(withPhoto photo: Photo) {
        self.photo = photo
    }
}

//MARK: - Save/Cancel

extension EditPhotoViewModel {
    func save() {
        photo.image = editedPhoto
        cancel()
    }
    
    func cancel() {
        editedPhoto = nil
        firstEditSourceTag = nil
        imageView?.image = photo.image
        saveButton?.isEnabled = hasPerformedChanges
    }
}

//MARK: - Filters

extension EditPhotoViewModel {
    
    func applySepiaToPhoto(_ sepia: Float) {
        applyFilterToPhoto(withName: "CISepiaTone", parameterName: kCIInputIntensityKey, intensity: sepia, notificationTag: .first)
    }
    
    func applyBrightnessToPhoto(_ brightness: Float) {
        applyFilterToPhoto(withName: "CIColorControls", parameterName: "inputBrightness", intensity: brightness, notificationTag: .second)
    }
    
    func applySaturationToPhoto(_ saturation: Float) {
        applyFilterToPhoto(withName: "CIColorControls", parameterName: "inputSaturation", intensity: saturation, notificationTag: .third)
    }
    
    func applyFilterToPhoto(withName name: String, parameterName: String, intensity: Float, notificationTag: AdjustmentSliderTags) {
        
        notificationLabelFor(notificationTag)?.text = String(format: "%.1f", intensity)
        firstEditSourceTag = firstEditSourceTag ?? notificationTag
        
        let context = CIContext(options: nil)
        
        if let currentFilter = CIFilter(name: name) {
            
            guard let photo = firstEditSourceTag == notificationTag ? photo.image : editedPhoto else { return }
            let beginImage = CIImage(image: photo)
            
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(intensity, forKey: parameterName)
            
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    editedPhoto = processedImage
                    imageView?.image = editedPhoto
                    saveButton?.isEnabled = hasPerformedChanges
                }
            }
        }
    }
}

//MARK: - Helper Methods

extension EditPhotoViewModel {
    
    var hasPerformedChanges: Bool {
        return editedPhoto != nil
    }
    
    func notificationLabelFor(_ tag: AdjustmentSliderTags) -> UILabel? {
        return notificationLabels?.first(where: { $0.tag == tag.rawValue })
    }
}
