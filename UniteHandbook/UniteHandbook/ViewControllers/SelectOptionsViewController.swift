//
//  SelectOptionsViewController.swift
//  UniteHandbook
//
//  Created by Jayme Rutkoski on 2/18/23.
//

import Foundation
import SnapKit
import UIKit

protocol SelectOptionsDelegate {
    func selectedOption(model: Any?)
}
class SelectOptionsViewController: UIViewController {
    
    private var images: [MultiImage] = [MultiImage]()
    private var delegate: SelectOptionsDelegate?
    
    private lazy var multiImageView: MultiImageView = {
        let view = MultiImageView(frame: .zero)
        view.backgroundColor = .clear
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: 0xc0b5e0)
        
        self.setup()
    }
    
    public convenience init(images: [MultiImage], delegate: SelectOptionsDelegate?) {
        self.init(nibName: nil, bundle: nil)
        self.images = images
        self.delegate = delegate
    }
    
    private func setup() {
        
        self.view.addSubview(self.multiImageView)
        self.multiImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(self.view.snp.left).offset(15)
            make.right.equalTo(self.view.snp.right).offset(-15)
            make.centerX.equalTo(self.view.snp.centerX)
        }

        self.multiImageView.delegate = self
        self.multiImageView.images = self.images
    }
}

extension SelectOptionsViewController : MultiImageViewDelegate {
    
    func imageSelected(forKey: Any?) {
        self.delegate?.selectedOption(model: forKey)
        self.dismiss(animated: true)
    }
}
