//
//  NetworkService.swift
//  KitoPlastic
//
//  Created by Apple on 16/05/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import Alamofire

class networkServices{
    
    static let shared = networkServices()
    //Mark:- This method is used for get .post data without header
    func postDatawithoutHeader(methodName:String,parameter:[String:Any],completion: @escaping (Any) -> Void){
        let url = URL(string: (BaseURL + methodName))
        Alamofire.request(url!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            switch (response.result){
            case .success(_):
                if let data = response.result.value
                {
                    print(response.result.value as Any)
                    print(data)
                    DispatchQueue.main.async {
                        completion(data)}
                }
                break
            case .failure(_):
                 print(response.result.error!)
                break
            }
        }
        }
    
    
    //MARK:- Upload Audio
    func uploadAudio(methodName: String,audioData:Data?,name:String ,appendParam:[String:String],completion: @escaping (Any)->Void){
          let url = URL(string:BaseURL + methodName)
          let headers = [ "userId" : "\(UserDefaults.standard.value(forKey: "USERID") ?? "")"]
          let manager = Alamofire.SessionManager.default
          manager.session.configuration.timeoutIntervalForRequest = 100000
          Alamofire.upload(multipartFormData: { multipartFormData in
               //import image to request
              multipartFormData.append(audioData!, withName: name, fileName: "songs.m4a", mimeType: "songs/m4a")
              
              for (key, value) in appendParam {
                  multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
              }

          },               to: url!,headers:(headers))
          { (result) in
              switch(result) {
                  
              case .success(let upload, _, _):
                  
                  upload.uploadProgress(closure: { (progress) in
                      print("Upload Progress: \(progress.fractionCompleted)")
                  })
                  DispatchQueue.main.async {
                      upload.responseJSON { response in
                          completion(response.result.value)
                      }
                  }
              case .failure(let encodingError):
                  print(encodingError)
              }
          }
      }
   
    //MARK:- Post Api
    func getPost(action:String,param: [String:Any],onSuccess: @escaping(DataResponse<Any>) -> Void, onFailure: @escaping(Error) -> Void){
        
        let url : String = BaseURL + action
        
        print(param)
       print(url)
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    //   print("response = ",response.result.value!)
                    onSuccess(response)
                    
                }
                break
            case .failure(_):
                onFailure(response.result.error!)
                print("error",response.result.error!)
                break
                
            }
        }
    }
    
    func getpostdata(action:String,parameter:[String:String],onSuccess: @escaping(DataResponse<Any>) ->Void,onFailure: @escaping(Error)-> Void){
        let url = ""
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch (response.result){
            case .success(_):
                if response.result.value != nil{
                    onSuccess(response)
                }
                break
            case .failure(_):
                onFailure(response.result.error!)
                break
            }
        }
    
    }
    
    
    //Mark:- This method is used for get .post data with header and with parameter
    func postDatawithHeader(methodName:String ,parameter:[String:Any], completion: @escaping (Any) -> Void){
    let url = URL(string: (BaseURL + methodName))
    let Header = ["AuthorizationToken" : UserDefaults.standard.value(forKey: "usertoken") as! String,
                  "userId" : UserDefaults.standard.value(forKey: "userid") as! String]

        Alamofire.request(url!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: Header).responseJSON{ response in
        switch (response.result){
        case .success(_):
            if let data = response.result.value
            {
                print(response.result.value as Any)
                print(data)
                DispatchQueue.main.async {
                    completion(data)}
            }
            break
        case .failure(_):
            print(response.result.error!)
            break
        }
        }
        }
    
    //Mark:- This method is used for get .post data with header and without parameter
    func postDataWithoutParameter(methodname:String, Completion: @escaping (Any) -> Void){
        let url = URL(string: (BaseURL + methodname))
        let Header = ["AuthorizationToken" : UserDefaults.standard.value(forKey: "usertoken") as! String ,
                      "userId" : UserDefaults.standard.value(forKey: "userid") as! String]
        
        Alamofire.request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: Header).responseJSON { (response) in
            switch (response.result){
                
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value as Any)
                    print(data)
                    DispatchQueue.main.async {
                        Completion(data)}
                }
                break
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }
    
    //MARK:- =============== MULTIPART Image Post API =========================
    func getMultipart(action:String, param : [String:String],imageData: Data?, onSuccess: @escaping(NSDictionary) -> Void, onFailure: @escaping(Error) -> Void){
        let Header = ["AuthorizationToken" : UserDefaults.standard.value(forKey: "usertoken") as! String ,
                      "userId" : UserDefaults.standard.value(forKey: "userid") as! String]
          Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            multipartFormData.append(imageData!, withName: "profile_pic", fileName: "file.png", mimeType: "image/png")
            
           },usingThreshold: UInt64.init(),to: BaseURL+action,method: .post, headers:Header)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                upload.responseJSON { DataResponse in
                    if DataResponse.result.value != nil {
                        onSuccess(DataResponse.result.value as! NSDictionary)
                    }
                }
            case .failure(_):
                
                break
            }
        }
        
    }
    //MARK: MULTIPART API without Header
    func postMultipartImageWithoutHeader(action:String,param: [String:Any],imageData: Data?, onSuccess: @escaping(NSDictionary) -> Void, onFailure: @escaping(Error) -> Void){

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            multipartFormData.append(imageData!, withName: "profile_pic", fileName: "file.jpg", mimeType: "image/jpg")
            
            
        }, to: BaseURL+action)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                upload.responseJSON { DataResponse in
                    if DataResponse.result.value != nil {
                        onSuccess(DataResponse.result.value as! NSDictionary)
                    }
                }
            case .failure(_):
                
                break
            }
        }
        
    }
    
    //Mark:- This method is used for get .get data with header and without parameter
    func getDataWithoutParameter(methodname:String, Completion: @escaping (Any) -> Void){
        let url = URL(string: (BaseURL + methodname))
        let Header = ["AuthorizationToken" : UserDefaults.standard.value(forKey: "usertoken") as! String ,
                      "userId" : UserDefaults.standard.value(forKey: "userid") as! String]
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Header).responseJSON { (response) in
            switch (response.result){
                
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value as Any)
                    print(data)
                    DispatchQueue.main.async {
                        Completion(data)}
                }
                break
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }
    
    //MARK:- This method is post data without Header without parameter
    func postDatawithoutHeaderWithoutParameter(methodName:String,completion: @escaping (Any) -> Void){
        let url = URL(string: (BaseURL + methodName))
        print(url)
        Alamofire.request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            switch (response.result){
            case .success(_):
                if let data = response.result.value
                {
                    print(response.result.value as Any)
                    print(data)
                    DispatchQueue.main.async {
                        completion(data)}
                }
                break
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }
    //MARK:- This method is .Get data without Header without parameter
    
    func GetDataWithoutParameterWithoutHeader(methodname:String, Completion: @escaping (Any) -> Void){
        let url = URL(string: (BaseURL + methodname))
        
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch (response.result){
                
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value as Any)
                    print(data)
                    DispatchQueue.main.async {
                        Completion(data)}
                }
                break
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }
    //MARK:- This method is .Get data without Header without parameter
    
    func GetDatawithoutHeader(methodName:String ,parameter:[String:Any], completion: @escaping (Any) -> Void){
        let url = URL(string: (BaseURL + methodName))
        Alamofire.request(url!, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            switch (response.result){
            case .success(_):
                if let data = response.result.value
                {
                    print(response.result.value as Any)
                    print(data)
                    DispatchQueue.main.async {
                        completion(data)}
                }
                break
            case .failure(_):
                print(response.result.error!)
                break
            }
        }
    }

   
}
extension UIViewController : URLSessionDataDelegate,URLSessionTaskDelegate,URLSessionDelegate{
    //MARK:=================================  UPLOAD IMAGE ==========================================
    func uploadImage(urlString:String,params:[String:Any]?,imageKeyValue:String?,image:UIImage?,success:@escaping ( _ response: NSDictionary)-> Void, failure:@escaping ( _ error: Error) -> Void){
        
        let boundary: String = "------VohpleBoundary4QuqLuM1cE5lMwCy"
        let contentType: String = "multipart/form-data; boundary=\(boundary)"
        let headers = [ "content-type": "application/json"]
        var request = URLRequest(url: URL(string: urlString)!)
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 60
        request.httpMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        //which field you have to sent image on server
        let fileName: String = imageKeyValue!
        if image != nil {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fileName)\"; filename=\"image.png\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type:image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image!.jpegData(compressionQuality: 0.1)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        //  let session = URLSession.shared
        let session = URLSession(configuration:.default, delegate: (self as! URLSessionDelegate), delegateQueue: .main)
        
        // var session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            //   print(data as Any)
            DispatchQueue.main.async {
                // self.hideProgress()
                
                if(error != nil){
                    //  print(String(data: data!, encoding: .utf8) ?? "No response from server")
                    
                    failure(error!)
                    
                }
                if let responseData = data{
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                        //      print(json)
                        success(json as! NSDictionary)
                        
                    }catch let err{
                        //    print(err)
                        
                        failure(err)
                        
                    }
                }
                
            }
            
        }
        task.resume()
    }
}

