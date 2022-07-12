//
//  DogApiHelper.swift
//  DogAPI
//
//  Created by Savitha M K on 2022-06-09.
//

import Foundation

class  DogApiHelper {
    private static let baseUrl = URL(string: "https://dog.ceo/api/breeds/list/all")!
    
    
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
                        }else{
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
    
    
    
    /*static func fetchJSONserial(callback: @escaping ([String] )->Void){
        let request = URLRequest(url: baseUrl)
        var subBreeds: [String] = []
        let task = session.dataTask(with: request) {
            data, _, error in
            
            
            if let data = data {
                do {
                    let jsondObject = try JSONSerialization.jsonObject(with: data, options: [])
                    guard
                        let jsonDictionary = jsondObject as? [AnyHashable: Any],
                         let message = jsonDictionary["message"] as? [String: [String]]
                    else {return}
                    for breed in message{
                        if (breed.value.count  > 0) {
                            subBreeds = breed.value
                            print(subBreeds)
                        }
                    }
                   
                   callback(subBreeds)
                } catch let e {
                    print ("something went wrong with the Serialization : \(e)")
               }
            }
        }
        task.resume()
    }*/
    
}
