//
//  CatModel.swift
//  NyaMeow
//
//  Created by Natalia Rojek on 04/01/2023.
//
//  Review Pending

import Foundation

protocol CatManagerDelegate: AnyObject {
    func didFailWithError(error: Error)
    func setCatImage(_ catManager: CatManager, catModel: [CatImageModel])
    func setCatFact(_ catManager: CatManager, catModel: CatFactModel)
}

struct CatManager {
    // setting up urls for the API calls
    private let imageApiUrl = "https://api.thecatapi.com/v1/images/search"
    private let factApiUrl = "https://meowfacts.herokuapp.com"
    var delegate: CatManagerDelegate?
    
    func getCatFactData() {
        // perform request for a cat fact
        performFactAPICall(with: factApiUrl)
    }
    
    func getCatImageData() {
        // perform request for an image
        performImageAPICall(with: imageApiUrl)
    }
    
    func performFactAPICall(with stringURL: String) {
        if let apiURL = URL(string: stringURL) {
            let task = URLSession.shared.dataTask(with: apiURL) { data, _, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let factData = parseJSONFact(data: safeData) {
                        delegate?.setCatFact(self, catModel: factData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func performImageAPICall(with stringURL: String) {
        if let apiURL = URL(string: stringURL) {
            let task = URLSession.shared.dataTask(with: apiURL) { data, _, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let imageData = parseJSONImage(data: safeData) {
                        delegate?.setCatImage(self, catModel: imageData)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSONImage(data: Data) -> [CatImageModel]? {
        // decoding JSON image data to swift
        let decoder = JSONDecoder()
        do {
            let results = try decoder.decode([CatImageModel].self, from: data)
            return results
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    private func parseJSONFact(data: Data) -> CatFactModel? {
        // decoding JSON fact data to swift
        let decoder = JSONDecoder()
        do {
            let results = try decoder.decode(CatFactModel.self, from: data)
            return results
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
