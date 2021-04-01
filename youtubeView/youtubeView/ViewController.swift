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
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
}

extension ViewController {
    func initView() {
        image.layer.cornerRadius = 10
        showVideoBtn.addTarget(self, action: #selector(didTabImage), for: .touchUpInside)
    }
}

extension ViewController {
    @objc func didTabImage() {
        let storyboard = UIStoryboard(name: "VideoViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController else {fatalError()}
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
}
