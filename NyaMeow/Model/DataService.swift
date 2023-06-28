//
//  LikesService.swift
//  NyaMeow
//
//  Created by Natalia Rojek on 09/03/2023.
//
//  Review Pending

import UIKit
import CoreData

struct DataService {
    var likeArray: [Like] = []
    var imageArray: [Image] = []

    // swiftlint:disable:next force_cast
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var shared = DataService()
    
    mutating func saveLike(_ text: String) {
        // creating new like as a constant
        let newLike = Like(context: context)
        newLike.fact = text
        
        // saving new like into an array of likes
        likeArray.append(newLike)
        
        // adding id to the like and saving it in database
        updateLikesID()
    }
    
    mutating func updateLikesID() {
        // creating a new updated array of likes
        var updatedLikeArray: [Like] = []
        
        // now we take the position of every like in the outdated array and save it as its ID
        // so if for example like1 is an element of an array: likeArray[2] then its ID = 2
        for like in likeArray {
            if let likeID = likeArray.firstIndex(of: like) {
                like.id = Int16(likeID)
            }
            // we save the like and its ID into the updated array
            updatedLikeArray.append(like)
        }
        // set the updated array as likeArray
        likeArray = updatedLikeArray
        // save changes in database
        saveContext()
    }
    
    mutating func loadLikes() {
        // fetching all likes from database and saving them in likeArray
        let request: NSFetchRequest<Like> = Like.fetchRequest()
        do {
            likeArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    mutating func getLikes() -> [Like] {
        // fetching all likes from database and saving them in likeArray
        loadLikes()
        // returning likeArray so other views can use it
        return likeArray
    }
    
    mutating func deleteLike(at currentRow: Int) {
        // delete like at current row - if user deleted a like at the third row delete third like in the array
        // deleting from database first
        context.delete(likeArray[currentRow])
        // then deleting from likeArray
        likeArray.remove(at: currentRow)
        
        // updating likes' id
        updateLikesID()
    }
    
    func saveContext() {
        // saving any changes made in database
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    mutating func loadImageData() {
        // fetching image data from database and saving it in imageArray
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        do {
            imageArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    mutating func getImageData() -> [Image] {
        // fetching image data from database and saving it in imageArray
        loadImageData()
        // then returning the imageArray
        return imageArray
    }
    
    mutating func saveImageData(date: String, imageURL: String) {
        // creating newImage as a constant
        let newImage = Image(context: context)
        
        // saving newImage's date as today's date that we passed when calling the function
        newImage.downloadDate = date
        // saving newImage's url that we passed when calling the function
        newImage.imageURL = imageURL
        // saving newImage into imageArray
        imageArray.append(newImage)
        // saving it in database
        saveContext()
    }
    
    func wasImageDisplayedToday(todaysDate: String) -> Bool {
        // making a fetch request for all image data
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        // setting up a predicate which will compare images' data to today's date
        fetchRequest.predicate = NSPredicate(format: "downloadDate == %@", todaysDate)
        
        // saving our result in the dates array
        var dates: [Image] = []
        do {
            dates = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        // checking if dates array is empty
        if dates.isEmpty {
            // if its empty it means that there was no image in database with todays date
            // that means that we have to provide a new image for today and make an API call
            // func wasImageDisplayedToday returns false -> it wasnt
            return false
        } else {
            // if its not empty it means that there is at least one image with todays date
            // that means that we dont need to make an API call
            // instead we have to display todays image
            // func wasImageDisplayedToday returns true -> it was
            return true
        }
    }
}
