//
//  DogImageViewController.swift
//  DogAPI
//
//  Created by Savitha M K on 2022-07-11.
//

import UIKit

class DogImageViewController: UIViewController {
    
    var breedName:String = ""
    
    @IBOutlet weak var dogImageView: UIImageView!
    
    @IBAction func dogImageRefreshAction(_ sender: UIButton) {
        DogApiHelper.fetchDogImage(breed: breedName) { response in
            switch response{
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.dogImageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        DogApiHelper.fetchDogImage(breed: breedName) { response in
            switch response{
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.dogImageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
