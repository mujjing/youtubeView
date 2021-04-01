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
            
        } else if gesture.state == .ended {//움직임이 멈췄을 때
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
                imageView.transform = .identity
                self.view.layoutIfNeeded()
            }) // 스프링 처럼 튀어오르는 효과주기
        }
    }
}
