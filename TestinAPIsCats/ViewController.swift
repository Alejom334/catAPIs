//
//  ViewController.swift
//  TestinAPIsCats
//
//  Created by Alejandro Martinez on 7/14/19.
//  Copyright © 2019 Alejandro Martinez. All rights reserved.
//

import UIKit


//1. In order to translate a JSON we must start by creating a struct that matches the type of dictionary structure that provides the JSON document. For the purpose of this tutorial we match the variables names for simplicity. The struct should follow the protocol Decoable or Codable. This means that the protocol is adecuate to read the JSON in swift.

struct aleJSON : Codable{
//        let id: String
//        let author: String
//        let width: Int
//        let height: Int
        let url: String?
        let download_url: String?
    }


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        callURL()
        // Do any additional setup after loading the view.
    }

//2. We created a global array that will hold the urls that we get from the JSON file
    var photos: [URL] = []
    
//3. These images also come from the JSON file. However, here we have translated the image completely to an array of UIImages
    var photospic: [UIImage] = []

//4. This variable comes directtly from the storyBoard and it is where we are going to be showing the images
    @IBOutlet var imageCat: UIImageView!
    
    func callURL () {
        
        //What is Networking? Communicating with a server over the internet.
        
        //URLSession: The URL Session object coordinates a group of related network data transfer tasks. URLSession class and realted classes provide an API for downloading data.
        
        //URLSessionConfiguration: is an object that defines the behavior and polices to use when we will be downloading and uploading data. URL Session is initialized usuing URLSessionConfiguration. There are 3 types of URLSessionConfigurations; .default, .ephermal, .background.
        //          .default: URLSession will save chache/cookie into disk, credentials are                     saved to keychain
        //          .ephermal: cache/cookie/credential are stored in memory and will be gone                    once the session is terminated
        //          .background: session upload/download task in the background meaning even                      if the app is suspended (in background) the upload/download
        //                       task will still continue
        
        //Now we need the URLSessionTask: This is the class responsible for making the request for the WEB API and uploading/Downloading the data
        
        //Now there are 3 types of data request:
        // - DataTask: send/recieve data with DataTask. This only holds the data on ram.
        // - DownloadTask: this downloads data with DownloadTasks. This type of download actually downloads a temporary file that should be store locally.
        // - UploadTask: Here we upload data to the server. A post should be made with a URLRequest.
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        let url = URL(string: "https://picsum.photos/v2/list")!
        //When dealing with DataTask we must follow 3 parameters Data, Response, Error. The data basically states the type of data that the url has. The response of the server must configured with the required protocol HTTPURLRESPONSE. The error we happened to have it after the Do statement.
        let task = session.dataTask(with: url){
            (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data else {return}
            
           
            do{
                let decoder = JSONDecoder()
                let digest = try decoder.decode([aleJSON].self, from: data)
                print("Alejo is here")
                for item in digest {
                    if let imageURL = item.download_url {
                        let url = URL(string: imageURL)!
                        let data = try Data(contentsOf: url)
                        if let imageToLoad = UIImage(data: data) {
                            self.photos.append(url)
                            self.photospic.append(imageToLoad)
                            
                        }
                        //self.photos.append(url)
                    }
                }
//                let queue = OperationQueue.main
//                queue.addOperation {
//                    self.imageCat.image = self.photospic.first
//                }
                
            }catch {
                print(error)
            }
        }
        task.resume()
    }
    
    @IBAction func next(_ sender: Any) {
        
            let contentURL = photos.randomElement()
            let data = try? Data(contentsOf: contentURL!)
                    if let imageToLoad = UIImage(data: data!){
                        self.imageCat.image = imageToLoad
        }
    }
}
