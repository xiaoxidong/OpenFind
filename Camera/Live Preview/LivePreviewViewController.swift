//
//  LivePreviewViewController.swift
//  Camera
//
//  Created by Zheng on 11/21/21.
//  Copyright © 2021 Andrew. All rights reserved.
//

import UIKit
import AVFoundation

class LivePreviewViewController: UIViewController {
    
    @IBOutlet weak var previewContainerView: UIView!
    
    /// same bounds as `view`, contains the safe view
    @IBOutlet weak var safeViewContainer: UIView!
    @IBOutlet weak var safeView: UIView!
    
    @IBOutlet weak var safeViewLeftC: NSLayoutConstraint!
    @IBOutlet weak var safeViewTopC: NSLayoutConstraint!
    @IBOutlet weak var safeViewWidthC: NSLayoutConstraint!
    @IBOutlet weak var safeViewHeightC: NSLayoutConstraint!
    
    /// original, unscaled image size (pretty large)
    var imageSize: CGSize?
    
    /// image scaled down to the view
    var imageFitViewSize = CGSize.zero
    
    /// image filling the safe view
    var imageFillSafeRect = CGRect.zero
    
    /// hugging the image
    /// BUT, will be scaled to different aspect - normal or full screen.
    @IBOutlet weak var previewFitView: UIView!
    @IBOutlet weak var previewFitViewLeftC: NSLayoutConstraint!
    @IBOutlet weak var previewFitViewTopC: NSLayoutConstraint!
    @IBOutlet weak var previewFitViewWidthC: NSLayoutConstraint!
    @IBOutlet weak var previewFitViewHeightC: NSLayoutConstraint!
    
    /// the frame of the scaled preview fit view, relative to `view`
    /// this basically adds the scale transforms to `previewFitView.frame`
    var previewFitViewFrame = CGRect.zero
    
    var previewFitViewScale = CGAffineTransform.identity
    /// the frame of the safe view, from `previewFitView`'s bounds
    var safeViewFrameFromPreviewFit = CGRect.zero
    
    /// directly in view hierarchy
    @IBOutlet weak var testingView: UIView!
    @IBOutlet weak var testingView2: UIView!
    
    /// should match the frame of the image
    @IBOutlet weak var drawingView: UIView!
    
    /// inside the drawing view, should match the safe view
    @IBOutlet weak var simulatedSafeView: UIView!
    
    /// don't scale this
    @IBOutlet weak var previewContentView: UIView!
    
    /// scale to safe area
    @IBOutlet weak var livePreviewView: LivePreviewView!
    @IBOutlet weak var pausedImageView: UIImageView!
    
    /// in case no camera was found
    var findFromPhotosButtonPressed: (() -> Void)?
    
    let session = AVCaptureSession()
    let videoDataOutput = AVCaptureVideoDataOutput()
    let photoDataOutput = AVCapturePhotoOutput()
    var cameraDevice: AVCaptureDevice?
    var captureCompletionBlock: ((UIImage) -> Void)?
    
    
    
    /// `true` = became `.aspectFill`
    var hitAspectTarget = false
    var aspectProgressTarget = CGFloat(1)
    
    /// `imageSize` updated, now update the aspect ratio
    var needSafeViewUpdate: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        livePreviewView.videoPreviewLayer.frame = previewFitView.bounds
    }
    
    func setup() {
        configureCamera()
        pausedImageView.alpha = 0
        livePreviewView.backgroundColor = .clear
        previewContentView.mask = safeViewContainer
        
        safeViewContainer.backgroundColor = Debug.tabBarAlwaysTransparent ? .blue : .clear
        safeView.backgroundColor = .blue
        
//        drawingView.addDebugBorders(.systemOrange)
//        simulatedSafeView.addDebugBorders(.systemGreen)
        livePreviewView.addDebugBorders(.yellow)
        testingView.addDebugBorders(.red)
        previewFitView.addDebugBorders(.green)
//        testingView2.addDebugBorders(.white)
//        aspectProgressView.addDebugBorders(.systemBlue)
        
        simulatedSafeView.backgroundColor = .systemGreen.withAlphaComponent(0.3)
        simulatedSafeView.layer.borderColor = UIColor.systemGreen.cgColor
        simulatedSafeView.layer.borderWidth = 5
        
    }
}


