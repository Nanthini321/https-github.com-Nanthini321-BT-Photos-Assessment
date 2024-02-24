//
//  ViewController.swift
//  BT-Photos-Assessment
//
//  Created by Nanthini on 23/02/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    let dataViewModel = PhotosViewModel()
    var enteredAlbumId = 0
    var errorMessageView: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        self.numberTextField.delegate = self
        self.photosCollectionView.delegate = self
        self.photosCollectionView.dataSource = self
        self.photosCollectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        self.customDoneBtn()
    }
    
    private func loadData() {
        dataViewModel.getPhotosList(albumId: enteredAlbumId) {
            DispatchQueue.main.async {
                self.photosCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func sendBtnAction(_ sender: Any) {
        self.numberTextField.resignFirstResponder()
        
        if self.numberTextField.text == "" || self.numberTextField.text == nil {
            self.warningLbl.isHidden = false
        }else{
            self.warningLbl.isHidden = true
            self.loadData()
        }
        
    }
    
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataViewModel.photosList.count < 1 {
            self.noDataLbl.isHidden = false
            return 0
        }else{
            self.noDataLbl.isHidden = true
            return self.dataViewModel.photosList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.loadCellData(model: self.dataViewModel.photosList[indexPath.row])
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let main = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detailViewController = main.instantiateViewController(identifier: "DetailsViewController") as! DetailsViewController
        let selectedIndex = self.dataViewModel.photosList[indexPath.row]
        detailViewController.selectedIndex = selectedIndex
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
extension HomeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            self.enteredAlbumId = 0
            return true
        }
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let isNumber = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        
        if isNumber {
            if let text = textField.text, let newRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: newRange, with: string)
                
                if let number = Int(updatedText), (1...100).contains(number) {
                    enteredAlbumId = number
                    print("Entered AlbumId: \(enteredAlbumId)")
                    return true
                }
            }
        }
        return false
    }
    
    func customDoneBtn() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        numberTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneBtnTapped() {
        numberTextField.resignFirstResponder()
    }
}


