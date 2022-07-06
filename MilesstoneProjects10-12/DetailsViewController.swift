//
//  DetailsViewController.swift
//  MilesstoneProjects10-12
//
//  Created by Mehmet Can Şimşek on 6.07.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var detailsImageView: UIImageView!
    
    var selectedImageName: String?
    var currentImage: Int!
    var pictures =  [Image]()
    var image: Image!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        image = pictures[currentImage]
        guard let image = image else {return}
        let path = getImageURL(for: image.image)
        detailsImageView.image = UIImage(contentsOfFile: path.path)
        
        if let chosenImage = selectedImageName {
            title = "\(chosenImage)"
        }
        
        
        
        
      
    }
    
    func getImageURL(for imageName: String) -> URL {
            return getDocumentsDirectory().appendingPathComponent(imageName)
        }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
