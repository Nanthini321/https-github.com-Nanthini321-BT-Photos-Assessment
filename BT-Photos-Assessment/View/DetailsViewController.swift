//
//  DetailsViewController.swift
//  BT-Photos-Assessment
//
//  Created by Nanthini on 23/02/24.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var selectedIndex: PhotosModel?
    
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var placeholderImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UIConfigure()
    }
    
    private func UIConfigure() {
        
        self.idLbl.text = "Photo id: \(self.selectedIndex?.id ?? 0)"
        self.titleLbl.text = "\(self.selectedIndex?.title ?? "")"
        let imageUrl = self.selectedIndex?.url ?? ""
        guard let url = URL(string: imageUrl) else { return }
        UIImage.loadFrom(url: url) { image in
            self.placeholderImgView.image = image
        }
        self.placeholderImgView.layer.cornerRadius = 5
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backBtnAction))
        backButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
