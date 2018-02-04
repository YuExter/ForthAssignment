//
//  MentionImageViewController.swift
//  FourthAssignment
//
//  Created by Юля Пономарева on 04.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit

class MentionImageViewController: UIViewController {
    fileprivate var imageView = UIImageView()
    
    fileprivate var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            self.imageView.image = newValue
            self.imageView.sizeToFit()
            self.scrollView?.contentSize = self.imageView.frame.size
            self.scaleImage()
        }
    }
    
    @IBOutlet fileprivate var scrollView: UIScrollView! {
        didSet {
            self.scrollView.delegate = self
            self.scrollView.minimumZoomScale = 0.2
            self.scrollView.maximumZoomScale = 1.0
            self.scrollView.contentSize = self.imageView.frame.size
            self.scrollView.addSubview(self.imageView)
        }
    }
    
    var url: URL? {
        didSet {
            self.image = nil
            self.fetchImage()
        }
    }
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.image == nil {
            self.fetchImage()
        }
    }
    
    fileprivate func fetchImage() {
        guard
            let url = self.url,
            let data = try? Data(contentsOf: url) else { return }
        
        self.image = UIImage(data: data)
    }
    
    fileprivate func scaleImage() {
        if let image = self.image {
            self.scrollView.zoomScale = max(self.scrollView.bounds.size.width / image.size.width, self.scrollView.bounds.size.height / image.size.height)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.scaleImage()
    }
}


// MARK: UIScrollViewDelegate
extension MentionImageViewController: UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
