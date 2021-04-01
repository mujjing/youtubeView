//
//  VideoViewController.swift
//  youtubeView
//
//  Created by Jh's Macbook Pro on 2021/04/01.
//

import UIKit

class VideoViewController: UIViewController {

    @IBOutlet weak var BackView: UIView!
    @IBOutlet weak var baseBackGrountView: UIView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoImageViewTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.baseBackGrountView.alpha = 1
        }
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension VideoViewController {
    func initView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panVideoImageView))
        videoImageView.addGestureRecognizer(panGesture)
    }
}

extension VideoViewController {
    
    @objc func panVideoImageView(gesture: UIPanGestureRecognizer) {
        
        guard let imageView = gesture.view else { return }
        let move = gesture.translation(in: imageView)
        
        if gesture.state == .changed {//이미지가 움직일 때
            
            imageView.transform = CGAffineTransform(translationX: 0, y: move.y) // x값은 변하지 않은채 y값만 변하면서 이미지가 움직인다
            
            //이미지뷰 좌우 padding 설정
            
            let movingConstant = move.y / 30
            
            if movingConstant <= 12 {
                videoImageViewTrailingConstraint.constant = movingConstant
                videoImageViewLeadingConstraint.constant = movingConstant
            }
            
            // 280(최대값) - 70(최소값) = 210 -> 화면 작아질 때 이미지 뷰 높이
            let parentViewHeight = self.view.frame.height
            let heightRatio = 210 / (parentViewHeight - (parentViewHeight / 6))
            let moveHeight = move.y * heightRatio
            
            videoImageViewHeightConstraint.constant = 280 - moveHeight
            
            //이미지뷰 가로 폭 움직임 150(최소값)
            let originalWidth = self.view.frame.width
            let minimumImageViewTrailingConstant = -(originalWidth - (150 + 12))
            let constant = originalWidth - move.y
            
            if minimumImageViewTrailingConstant > constant {
                videoImageViewTrailingConstraint.constant = -minimumImageViewTrailingConstant
                return
            }
            
            if constant < -12 {
                videoImageViewTrailingConstraint.constant = -constant
            }
            
        } else if gesture.state == .ended {//움직임이 멈췄을 때
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
                self.backToIdentityAllView(imageView: imageView as! UIImageView)
            }) // 스프링 처럼 튀어오르는 효과주기
        }
    }
    
    private func backToIdentityAllView(imageView: UIImageView) {
        imageView.transform = .identity
        self.videoImageViewHeightConstraint.constant = 280
        self.videoImageViewLeadingConstraint.constant = 0
        self.videoImageViewTrailingConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
}
