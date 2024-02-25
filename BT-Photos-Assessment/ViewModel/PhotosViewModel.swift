//
//  PhotosViewModel.swift
//  BT-Photos-Assessment
//
//  Created by Nanthini on 23/02/24.
//

import Foundation
import UIKit

class PhotosViewModel {
    var photosList = [PhotosModel]()
    var onError: ((String) -> Void)?
    
    func getPhotosList(albumId: Int, completion: @escaping () -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/albums/\(albumId)/photos"
        
        NetworkManager.fetchData(urlString: urlString) { [weak self] photosLists, error in
            if let error = error {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self?.onError?("Failed to fetch data. Please try again.")
                }
            }else if let dataLists = photosLists {
                self?.photosList = dataLists
                print("PhotosLists", dataLists)
                completion()
            }
        }
    }
    
}
