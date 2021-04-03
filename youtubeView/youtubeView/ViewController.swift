//
//  ViewController.swift
//  youtubeView
//
//  Created by Jh's Macbook Pro on 2021/04/01.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var showVideoBtn: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var bottomVideoView: UIView!
    @IBOutlet weak var bottomVideoViewLeading: NSLayoutConstraint!
    @IBOutlet weak var bottomVideoViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var bottomVideoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomVideoViewBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomVideoImageWidth: NSLayoutConstraint!
    @IBOutlet weak var bottomVideoImageHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupGestureRecognizer()
    }
}

extension ViewController {
    func initView() {
        view.bringSubviewToFront(bottomVideoView)
        bottomVideoView.isHidden = true
        image.layer.cornerRadius = 10
        showVideoBtn.addTarget(self, action: #selector(didTabImage), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(showImage), name: .init("thumbnailImage"), object: nil)
    }
    
    func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBottomVideoView))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panBottomVideoView))
        bottomVideoView.addGestureRecognizer(tapGesture)
        bottomVideoView.addGestureRecognizer(panGesture)
    }
    
    func bottomVideoViewExpandAnimation() {
        let topSafeArea = self.view.safeAreaInsets.top
        let bottomSafeArea = self.view.safeAreaInsets.bottom
        
        bottomVideoViewLeading.constant = 0
        bottomVideoViewTrailing.constant = 0
        bottomVideoViewBottom.constant = -bottomSafeArea
        bottomVideoViewHeight.constant = view.frame.height - topSafeArea
        //self.tabBarController?.tabBar.isHidden = true
        
        bottomVideoImageWidth.constant = view.frame.width
        bottomVideoImageHeight.constant = 280
        
        self.view.layoutIfNeeded()
    }
    
    private func bottomVideoViewBackToIdentity() {
        
        bottomVideoViewLeading.constant = 12
        bottomVideoViewTrailing.constant = 12
        bottomVideoViewBottom.constant = 66
        bottomVideoViewHeight.constant = 70
        //self.tabBarController?.tabBar.isHidden = true
        
        bottomVideoImageWidth.constant = 150
        bottomVideoImageHeight.constant = 70
        bottomVideoView.isHidden = true
        
    }
}

extension ViewController {
    @objc func didTabImage() {
        bottomVideoView.isHidden = true
        let storyboard = UIStoryboard(name: "VideoViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController else {fatalError()}
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func showImage(notification: NSNotification) {
        guard let userInfo = notification.userInfo as? [String : UIImage] else { return }
        let image = userInfo["image"]
        bottomVideoView.isHidden = false
        bottomImageView.image = image
        
    }
    @objc private func tapBottomVideoView() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
            
        self.bottomVideoViewExpandAnimation()
            
        } completion: { _ in
            let storyboard = UIStoryboard(name: "VideoViewController", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController else {fatalError()}
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false) {
                self.bottomVideoViewBackToIdentity()
            }
        }
    }
    
    @objc private func panBottomVideoView(sender: UIPanGestureRecognizer) {
        let move = sender.translation(in: view)
        
        guard let imageView = sender.view else { return }
        
        if sender.state == .changed {
            imageView.transform = CGAffineTransform(translationX: 0, y: move.y)
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
                imageView.transform = .identity
                self.view.layoutIfNeeded()
            }
        }
    }
}
