//
//  AppDelegate.swift
//  ImageCollage
//
//  Created by Sagar Thukral on 23/08/20.
//  Copyright © 2020 Sagar. All rights reserved.

import UIKit

protocol CollageDelegate {
    func collageImage(image:UIImage)
}

class ImagesModel : NSObject {
    var imgName = 1
    var isSelected = false
}

class CollageCollectionViewController: UIViewController {

    @IBOutlet var collageTypeCollection : UICollectionView!
    @IBOutlet var imagesView : UIView!
    var mediaResult = [UIImage]()
    @IBOutlet var horizontalStack : UIStackView!
    @IBOutlet var verticalStack : UIStackView!
    @IBOutlet var verticalStack2 : UIStackView!
    @IBOutlet var img1 : UIButton!
    @IBOutlet var img2 : UIButton!
    @IBOutlet var img3 : UIButton!
    @IBOutlet var img4 : UIButton!
    var imagePicker = UIImagePickerController()
    var currentTag = 0
    var frameType = SelectedFrame.One
    var delegate : CollageDelegate?
    var imagesModel = [ImagesModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addStaticFrames()
        
        
        self.createImagesView()
        // Do any additional setup after loading the view.
    }
    
    func addStaticFrames() {
        //Static frames
        self.mediaResult.append(UIImage(named: "one") ?? UIImage())
        self.mediaResult.append(UIImage(named: "two") ?? UIImage())
        self.mediaResult.append(UIImage(named: "twoHorizontal") ?? UIImage())
        self.mediaResult.append(UIImage(named: "three") ?? UIImage())
        self.mediaResult.append(UIImage(named: "four") ?? UIImage())
        
        //Model For Error Conditions
        for i in 1..<5 {
            let model = ImagesModel()
            model.imgName = i
            model.isSelected = false
            self.imagesModel.append(model)
        }
    }
    
    //Add Image Button Action
    @objc func addImgBtnAction(sender:UIButton) {
        
        let alert = UIAlertController.init(title: "Chooser", message: "Please select your option", preferredStyle: .alert)
        let actionCam = UIAlertAction(title: "Camera", style: .default) { UIAlertAction in
            self.uploadImageWithCamera(sender: sender)
        }
        
        let actionGallery = UIAlertAction(title: "Gallery", style: .default) { UIAlertAction in
            self.uploadImageWithLibrary(sender: sender)
        }
        alert.addAction(actionCam)
        alert.addAction(actionGallery)
        self.present(alert, animated: false, completion: nil)
        
        
    }
    
    //Add Image from Gallary
    @objc func uploadImageWithLibrary(sender:UIButton) {
        //Open Gallary
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            //            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            currentTag = sender.tag
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Add Image from Camera
    @objc func uploadImageWithCamera(sender:UIButton) {
        //Open Camera
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //            print("Button capture")
            currentTag = sender.tag
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Save Final Image
    @IBAction func saveImageBtnAction(_ sender:UIButton) {
        var isError = false
        switch self.frameType {
        case .One:
            let val1 = self.imagesModel.filter({$0.imgName == 1}).first?.isSelected ?? false
            if !val1 {
                isError = true
            }
        case .Two:
            let val1 = self.imagesModel.filter({$0.imgName == 1}).first?.isSelected ?? false
            let val2 = self.imagesModel.filter({$0.imgName == 2}).first?.isSelected ?? false
            if !val1 || !val2 {
                isError = true
            }
        case .Three:
           let val1 = self.imagesModel.filter({$0.imgName == 1}).first?.isSelected ?? false
           let val2 = self.imagesModel.filter({$0.imgName == 2}).first?.isSelected ?? false
           let val3 = self.imagesModel.filter({$0.imgName == 2}).first?.isSelected ?? false
            if !val1 || !val2 || !val3 {
                isError = true
            }
        case .Four:
            let val1 = self.imagesModel.filter({$0.imgName == 1}).first?.isSelected ?? false
            let val2 = self.imagesModel.filter({$0.imgName == 2}).first?.isSelected ?? false
            let val3 = self.imagesModel.filter({$0.imgName == 3}).first?.isSelected ?? false
            let val4 = self.imagesModel.filter({$0.imgName == 3}).first?.isSelected ?? false
            if !val1 || !val2 || !val3 || !val4 {
                isError = true
            }
        case .TwoHorizontal:
            let val1 = self.imagesModel.filter({$0.imgName == 1}).first?.isSelected ?? false
            let val2 = self.imagesModel.filter({$0.imgName == 2}).first?.isSelected ?? false
            if !val1 || !val2 {
                isError = true
            }
        }
        
        if isError {
            let alert = UIAlertController.init(title: "Error", message: "Please add all images or change your frame", preferredStyle: .alert)
            let OkAction = UIAlertAction(title: "Ok", style: .default) { UIAlertAction in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(OkAction)
            self.present(alert, animated: false, completion: nil)
        } else {
            let image: UIImage!

            // draw your UICollectionView into a UIImage
            UIGraphicsBeginImageContext(self.imagesView.frame.size)
            
            self.imagesView.layer.render(in: UIGraphicsGetCurrentContext()!)

            image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            self.delegate?.collageImage(image: image)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    //Arrange View According to frames
    func createImagesView() {
        for vv in self.horizontalStack.subviews {
            vv.removeFromSuperview()
        }
        for vv in self.verticalStack.subviews {
            vv.removeFromSuperview()
        }
        for vv in self.verticalStack2.subviews {
            vv.removeFromSuperview()
        }
        self.horizontalStack.isHidden = true
        self.verticalStack.isHidden = true
        self.verticalStack2.isHidden = true
        self.img1.isHidden = true
        self.img1.tag = 1
        self.img2.isHidden = true
        self.img2.tag = 2
        self.img3.isHidden = true
        self.img3.tag = 3
        self.img4.isHidden = true
        self.img4.tag = 4

        
        switch self.frameType {
        case .One:
            
           self.horizontalStack.isHidden = false
           self.horizontalStack.addArrangedSubview(img1)
            self.img1.isHidden = false
        case .Two:
           self.horizontalStack.isHidden = false
           self.horizontalStack.addArrangedSubview(img1)
           self.horizontalStack.addArrangedSubview(img2)
           self.img1.isHidden = false
           self.img2.isHidden = false
        case .TwoHorizontal:
            self.img1.isHidden = false
            self.img2.isHidden = false
            self.horizontalStack.isHidden = false
            self.horizontalStack.addArrangedSubview(self.verticalStack)
            self.verticalStack.isHidden = false
            self.verticalStack.addArrangedSubview(img1)
            self.verticalStack.addArrangedSubview(img2)
        case .Three:
            
            self.horizontalStack.isHidden = false
            self.horizontalStack.addArrangedSubview(img1)
            self.horizontalStack.addArrangedSubview(verticalStack)
            self.img1.isHidden = false
            
            self.verticalStack.isHidden = false
            self.verticalStack.addArrangedSubview(img2)
            self.verticalStack.addArrangedSubview(img3)
            self.img2.isHidden = false
            self.img3.isHidden = false
//            self.img4.isHidden = false
        case .Four:
            self.horizontalStack.isHidden = false
            self.horizontalStack.addArrangedSubview(self.verticalStack)
            self.verticalStack.isHidden = false
            self.verticalStack.addArrangedSubview(img1)
            self.verticalStack.addArrangedSubview(img2)
            
            self.horizontalStack.addArrangedSubview(self.verticalStack2)
            self.verticalStack2.isHidden = false
            self.verticalStack2.addArrangedSubview(img3)
            self.verticalStack2.addArrangedSubview(img4)
            
            self.img1.isHidden = false
            self.img2.isHidden = false
            self.img3.isHidden = false
            self.img4.isHidden = false

//            self.img5.isHidden = false
//            self.img6.isHidden = false

        }
        img1.addTarget(self, action: #selector(self.addImgBtnAction(sender:)), for: .touchUpInside)
        img2.addTarget(self, action: #selector(self.addImgBtnAction(sender:)), for: .touchUpInside)
        img3.addTarget(self, action: #selector(self.addImgBtnAction(sender:)), for: .touchUpInside)
        img4.addTarget(self, action: #selector(self.addImgBtnAction(sender:)), for: .touchUpInside)

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//Static Frames Collection View delegate and datasource
extension CollageCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        for val in self.imagesModel {
            if val.imgName == self.currentTag {
                val.isSelected = true
            }
        }
        switch self.currentTag {
        case 1:
            self.img1.setImage(image, for: .normal)
        case 2:
            self.img2.setImage(image, for: .normal)
        case 3:
            self.img3.setImage(image, for: .normal)
        case 4:
            self.img4.setImage(image, for: .normal)
        default:
            break
        }

        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mediaResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell ?? ImageCell()
        cell.bgView.backgroundColor = .white
        cell.imgView.image = self.mediaResult[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.frameType = .One
        case 1:
            self.frameType = .Two
        case 2:
            self.frameType = .TwoHorizontal
        case 3:
            self.frameType = .Three
        default:
            self.frameType = .Four
        }
        self.createImagesView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: 100, height: 140)
    }
    
    
    
}
enum SelectedFrame {
    case One
    case Two
    case TwoHorizontal
    case Three
    case Four
}
