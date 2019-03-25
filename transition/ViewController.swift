//
//  ViewController.swift
//  transition
//
//  Created by Bhavin Suthar on 20/03/19.
//  Copyright © 2019 cazzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionVIew: UICollectionView!
    var imageArr = [String]()
    var selectedImage = ""
    var selectedFrame:CGRect!
    var customInteractor:CustomInteractor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        for i in 1...38 {
            imageArr.append("image_\(i)")
            //UIImage.init(named: "image_\(i)")
        }
        self.collectionVIew.delegate = self
        self.collectionVIew.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.delegate = self

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! ViewController1).imageName = selectedImage
        //segue.destination.transitioningDelegate = self
    }
}
extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
       let image =  cell.viewWithTag(2) as! UIImageView
        image.image = UIImage.init(named: imageArr[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.bounds.width/3, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = imageArr[indexPath.row]
        let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        selectedFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
}
extension ViewController:UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationController.Operation.pop {
            return TransitionController.init(originFrame: selectedFrame,imageName: UIImage.init(named: selectedImage)!,present: false)
        }
       //For back swipe
        self.customInteractor = CustomInteractor(attachTo: toVC)
        //
        return TransitionController.init(originFrame: selectedFrame,imageName: UIImage.init(named: selectedImage)!)
    }
    // For back swipe
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = customInteractor else { return nil }
    
        return ci.transitionInProgress ? customInteractor : nil
    }
    //
    
}
