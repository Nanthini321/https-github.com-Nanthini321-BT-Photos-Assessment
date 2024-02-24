//
//  PhotoCollectionViewCell.swift
//  BT-Photos-Assessment
//
//  Created by Nanthini on 23/02/24.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func loadCellData(model: PhotosModel) {        
        let imageUrl = model.thumbnailUrl ?? ""
        guard let url = URL(string: imageUrl) else { return }
        UIImage.loadFrom(url: url) { image in
            self.thumbnailImageView.image = image
        }
        self.thumbnailImageView.layer.cornerRadius = 5
    }
}

extension UIImage {    
    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
