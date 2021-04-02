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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}

extension ViewController {
    func initView() {
        bottomVideoView.isHidden = true
        image.layer.cornerRadius = 10
        showVideoBtn.addTarget(self, action: #selector(didTabImage), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(showImage), name: .init("thumbnailImage"), object: nil)
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
}
