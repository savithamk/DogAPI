//
//  DogApiHelper.swift
//  DogAPI
//
//  Created by Savitha M K on 2022-06-09.
//

import Foundation

enum DogImageResult{
    case success(Data)
    case failure(Error)
}

struct DogImageData: Codable{
    var message: String
    var status: String
}


class  DogApiHelper {
    private static let baseUrl = URL(string: "https://dog.ceo/api/breeds/list/all")!
    
    private static let imageBaseUrl:String = "https://dog.ceo/api/breed/"
    
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration:config)
    }()
    
    static func fetchJSONserial(callback: @escaping ([String])->Void){
        let request = URLRequest(url: baseUrl)
        var dogList: [String] = []
        let task = session.dataTask(with: request) {
            data, _, error in
            
            
            if let data = data {
                do {
                    let jsondObject = try JSONSerialization.jsonObject(with: data, options: [])
                    guard
                        let jsonDictionary = jsondObject as? [AnyHashable: Any],
                         let message = jsonDictionary["message"] as? [String: [String]]

                    else {return}
                    
                    for breed in message {
                        if breed.value.isEmpty{
                            dogList.append(breed.key)
                        }
                        else{
                            for subBreed in breed.value{
                                dogList.append(breed.key+": "+subBreed)
                            }
                        }
                    }
                    dogList.sort()
                   callback(dogList)
                } catch let e {
                    print ("something went wrong with the Serialization : \(e)")
               }
            }
        }
        task.resume()
    }
    
    static func fetchDogImage(breed:String,callback: @escaping (DogImageResult) -> Void){
        guard
            let url: URL = URL(string: imageBaseUrl + breed + "/images/random")
            //let url: URL = URL(string: "https://images.dog.ceo/breeds/akita/Akita_Dog.jpg")
        else{
            callback(.failure("Cannot create URL to fetch Dog image" as! Error))
            return
        }
        
        print("url is \(url)")
       
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){ data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let imageURLResponse = try decoder.decode(DogImageData.self, from: data)
                    let imageRequest = URLRequest(url:URL(string: imageURLResponse.message)!)
                    
                    let imageTask = session.dataTask(with: imageRequest){imageData, _, error in
                        if let imageData = imageData {
                            callback(.success(imageData))
                        }else if let error = error {
                            callback(.failure(error))
                    }
                    }
                    imageTask.resume()
                    
                } catch let e{
                    callback(.failure(e))
                }
            } else if let error = error {
                    callback(.failure(error))
            }
        }
        task.resume()
        
    }
    
    
}
