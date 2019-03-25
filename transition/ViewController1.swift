//
//  ViewController1.swift
//  transition
//
//  Created by Bhavin Suthar on 20/03/19.
//  Copyright © 2019 cazzy. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {

  //  @IBOutlet weak var redView: UIView!
    
    @IBOutlet weak var image: UIImageView!
    var imageName:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
      image.image = UIImage.init(named: imageName)
        
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
