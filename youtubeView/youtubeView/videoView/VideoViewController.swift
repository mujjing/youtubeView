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
    @IBOutlet weak var videoImageBackView: UIView!
    
    @IBOutlet weak var describeView: UIView!
    @IBOutlet weak var describeViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backViewTrailingContraint: NSLayoutConstraint!
    @IBOutlet weak var backViewBottomConstraint: NSLayoutConstraint!
    
    var videoImageMaxY: CGFloat {
        let ecludeValue = (view.safeAreaInsets.bottom + (imageViewCenterY ?? 0))
        return view.frame.maxY - ecludeValue
    }
    var minimumImageViewTrailingConstant: CGFloat {
        -(view.frame.width - (150 + 12))
    }
    private var imageViewCenterY: CGFloat?
    
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
        self.view.bringSubviewToFront(videoImageView)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panVideoImageView))
        videoImageView.addGestureRecognizer(panGesture)
        
        imageViewCenterY = videoImageView.center.y
        print("videoImageMaxY : ", videoImageMaxY)
    }
}

extension VideoViewController {
    
    @objc func panVideoImageView(gesture: UIPanGestureRecognizer) {
        
        guard let imageView = gesture.view else { return }
        let move = gesture.translation(in: imageView)
        
        if gesture.state == .changed {//이미지가 움직일 때
            
            //이미지룰 작게 했을 시 이미지 뷰 최소높이(계속 아래로 드래그하더라도 최소 높이 이후론 변화 없음)
            if videoImageMaxY <= move.y {
                moveToBottom(imageView: imageView as! UIImageView)
                return
            }
            
            imageView.transform = CGAffineTransform(translationX: 0, y: move.y) // x값은 변하지 않은채 y값만 변하면서 이미지가 움직인다
            videoImageBackView.transform = CGAffineTransform(translationX: 0, y: move.y)
            //이미지뷰 좌우 padding 설정
            
            let movingConstant = move.y / 30
            
            if movingConstant <= 12 {
                videoImageViewTrailingConstraint.constant = movingConstant
                videoImageViewLeadingConstraint.constant = movingConstant
                
                backViewTrailingContraint.constant = movingConstant
            }
            
            // 280(최대값) - 70(최소값) = 210 -> 화면 작아질 때 이미지 뷰 높이
            let parentViewHeight = self.view.frame.height
            let heightRatio = 210 / (parentViewHeight - (parentViewHeight / 6))
            let moveHeight = move.y * heightRatio
            
            backViewTopConstraint.constant = move.y //이미지 움직일 때 backView Top부분 제약조건 이미지 뷰 y위치랑 같게 변동
            videoImageViewHeightConstraint.constant = 280 - moveHeight
            describeViewTopConstraint.constant = move.y * 0.8//이미지 움직일 때 decripbeView Top부분 제약조건 이미지 뷰 y변한 만큼 같이 위치 변동
            
            let bottomMoveY = parentViewHeight - videoImageMaxY
            let bottomMoveRatio = bottomMoveY / videoImageMaxY
            let bottomMoveConstant = move.y * bottomMoveRatio
            backViewBottomConstraint.constant = bottomMoveConstant
            
            // alpha값 설정
            let alphaRatio = move.y / ( parentViewHeight / 2)
            describeView.alpha = 1 - alphaRatio
            baseBackGrountView.alpha = 1 - alphaRatio
            
            //이미지뷰 가로 폭 움직임 150(최소값)
            let originalWidth = self.view.frame.width
            let miniImageViewTrailingConstant = -(originalWidth - (150 + 12))
            let constant = originalWidth - move.y
            
            if minimumImageViewTrailingConstant > constant {
                videoImageViewTrailingConstraint.constant = -miniImageViewTrailingConstant
                return
            }
            
            if constant < -12 {
                videoImageViewTrailingConstraint.constant = -constant
            }
            
        } else if gesture.state == .ended {//움직임이 멈췄을 때
            
            if move.y < self.view.frame.height / 3 {
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
                    self.backToIdentityAllView(imageView: imageView as! UIImageView)
                }) // 스프링 처럼 튀어오르는 효과주기
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: []) {
                    self.moveToBottom(imageView: imageView as! UIImageView)
                }
            }
        }
    }
    
    private func moveToBottom(imageView: UIImageView) {
        //imageView 설정
        imageView.transform = CGAffineTransform(translationX: 0, y: videoImageMaxY)
        videoImageViewTrailingConstraint.constant = -minimumImageViewTrailingConstant
        videoImageViewHeightConstraint.constant = 70
        
        videoImageBackView.transform = CGAffineTransform(translationX: 0, y: videoImageMaxY)
        BackView.alpha = 0
        describeView.alpha = 0
        baseBackGrountView.alpha = 0
        
        self.view.layoutIfNeeded()
    }
    
    private func backToIdentityAllView(imageView: UIImageView) {
        // imageView설정
        imageView.transform = .identity
        
        videoImageViewHeightConstraint.constant = 280
        videoImageViewLeadingConstraint.constant = 0
        videoImageViewTrailingConstraint.constant = 0
        
        //backView설정
        backViewTrailingContraint.constant = 0
        backViewBottomConstraint.constant = 0
        backViewTopConstraint.constant = 0
        BackView.alpha = 1
        
        //describeView설정
        describeViewTopConstraint.constant = 0
        describeView.alpha = 1
        
        baseBackGrountView.alpha = 1
        
        self.view.layoutIfNeeded()
    }
}
