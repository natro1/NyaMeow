//
//  ViewController.swift
//  NyaMeow
//
//  Created by Natalia Rojek on 03/01/2023.
//
//  Review Pending

import UIKit
import CoreData

class NyaMeowViewController: UIViewController {
    
    private let nyaMeowView = NyaMeowView()
    private var catManager = CatManager()
    private var likesView = LikesView()
    private let resources = Resources()
    private var isLiked = false
    private let currentDate = Date()
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting view in NyaMeowView
        view = nyaMeowView
        catManager.delegate = self
        
        // loading a cat fact when the view has loaded
        catManager.getCatFactData()
        
        loadOrDownloadDailyImage()
        
        // load saved likes so we can hit likes on nyaMeowView and update Likes in database at the same time
        DataService.shared.loadLikes()
        
        // setting up a like button <3 to hit likes
        let likeButton = nyaMeowView.likeButton
        
        // adding action to <3 button
        likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
        
        // setting up a saving button so we can save an image
        let saveImageButton = nyaMeowView.saveImageButton
        
        // adding action to a saving button
        saveImageButton.addTarget(self, action: #selector(saveImageButtonPressed(_:)), for: .touchUpInside)
    }
    
    // Setting up the navigation bar in viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavBar()
    }
    
    // hiding myLikesButton in navigation bar in viewWillDisappearr so its invisible in LikesView
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nyaMeowView.myLikesButton.isHidden = true
    }
    
    private func getStringDate() -> String {
        dateFormatter.dateFormat = resources.dateFormat
        let stringDate = dateFormatter.string(from: currentDate)
        return stringDate
    }
    
    private func loadOrDownloadDailyImage() {
        // loading image data saved in Database so we can check later if an image was displayed today
        DataService.shared.loadImageData()
        
        // making a boolean constant to check if image was displayed today
        let imageWasDisplayed = DataService.shared.wasImageDisplayedToday(todaysDate: getStringDate())
        
        if imageWasDisplayed {
            // image was displayed today
            // there is no need to download a new image url from API call
            // taking image url from coredata because we saved it when it was displayed for the first time
            if let stringURL = DataService.shared.imageArray.last?.imageURL {
                // we are now converting string url to URL type
                if let imageURL = URL(string: stringURL) {
                    // url -> data
                    URLSession.shared.dataTask(with: imageURL) { data, _, _ in
                        guard let imageData = data else {
                            return
                        }
                        // we take the data from the above and display image in catImageView
                        DispatchQueue.main.async { [weak self] in
                            self?.nyaMeowView.catImageView.image = UIImage(data: imageData)
                        }
                    }.resume()
                }
            }
        } else {
            // image was not displayed today
            // we have to make an API call to download an image for today
            catManager.getCatImageData()
        }
    }
    
    // action when user hits like <3
    @objc func likeButtonPressed(_ sender: UIButton) {
        if isLiked {
            // the fact is liked <3 when we tapped a button
            // it means that we UNLIKE a fact and have to delete it from database
            let lastLikeID = DataService.shared.likeArray.count
            DataService.shared.deleteLike(at: lastLikeID - 1)
            
        } else {
            // the fact is not liked </3
            // it means that we LIKE a fact so we have to saved it in database
            if let text = nyaMeowView.randomFactLabel.text {
                DataService.shared.saveLike(text)
            }
        }
        // now we have to change how this <3 button looks
        // if it was liked -> change it to empty heart (isLiked = false)
        // if it was unliked -> change it to full heart (isLiked = true)
        changeLikeButtonView(newValue: !isLiked)
    }
    
    // this function is called in LikesViewController when deleteButton is pressed
    // it exists because we need to change the <3 button view when the like is being deleted in the other view
    func compareAndDeleteLike(likeText: String?) {
        // if user deletes a like in LikesView we have to check if its currently displayed in NyaMeowView
        // if so, we have to update the <3 button because this fact is no longer liked
        // thats why we compare the randomFactLabel.text to likeText
        if nyaMeowView.randomFactLabel.text == likeText ?? "" {
            changeLikeButtonView(newValue: false)
        }
    }
    
    private func changeLikeButtonView(newValue: Bool) {
        // calling a function from the ViewConfiguration struct
        // changing button image to full or empty heart depending on newValue's value (true or false)
        nyaMeowView.likeButton.setImage(
            UIImage(named: newValue ? resources.fullHeartIcon : resources.emptyHeartIcon),
            for: .normal
        )
        
        // saving newValue in the isLiked variable
        isLiked = newValue
    }
    
    // saving an image to gallery
    @objc func saveImageButtonPressed(_ sender: UIButton) {
        
        if let imageData = nyaMeowView.catImageView.image?.pngData() {
            if let compressedImage = UIImage(data: imageData) {
                // saving
                UIImageWriteToSavedPhotosAlbum(compressedImage, nil, nil, nil)
                // making an alert that we succesfully saved a photo
                let alert = UIAlertController(
                    title: resources.savingPhotoAlertTitle,
                    message: resources.savingPhotoAlertMessage,
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: resources.okAlertButtonTitle, style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
            }
        }
    }
    
    // presenting LikesView
    @objc func myLikesButtonPressed(_ sender: UIButton) {
        let likesVC = LikesViewController()
        navigationController?.pushViewController(likesVC, animated: true)
    }
}

// MARK: - API Management
extension NyaMeowViewController: CatManagerDelegate {
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            print("There was an error: \(error)")
            
            let alert = UIAlertController(
                title: self.resources.noInternetAlertTitle,
                message: self.resources.noInternetAlertMessage,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: self.resources.okAlertButtonTitle, style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    // setting cat image from API
    func setCatImage(_ catManager: CatManager, catModel: [CatImageModel]) {
        // converting stringURL to URL
        if let imageURL = URL(string: catModel[0].url) {
            DispatchQueue.global().async {
                // URL -> data
                if let data = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async { [weak self] in
                        // setting catImageView to this image from API
                        self?.nyaMeowView.catImageView.image = UIImage(data: data)
                        // saving new image in database (date and url)
                        if let safeDate = self?.getStringDate() {
                            DataService.shared.saveImageData(date: safeDate, imageURL: catModel[0].url)
                        }
                    }
                }
            }
        }
    }
    // setting cat fact from API
    func setCatFact(_ catManager: CatManager, catModel: CatFactModel) {
        DispatchQueue.main.async { [weak self] in
            // put the text from API in a randomFactLabel
            self?.nyaMeowView.randomFactLabel.text = catModel.data[0]
            // show the factFrame right after the text is displayed
            self?.nyaMeowView.factFrame.isHidden = false
        }
    }
}

// MARK: - Navigation Bar

// setting up the navigation bar
extension NyaMeowViewController {
    func setUpNavBar() {
        // first check if navigation bar exists
        if let navBar = self.navigationController?.navigationBar {
            // set up large title and its attributes
            title = resources.nyaMeowTitle
            navBar.prefersLargeTitles = true
            navBar.largeTitleTextAttributes = nyaMeowView.textAttributes(
                fontSize: 40
            )
            
            // set up regular title attributes
            navBar.titleTextAttributes = nyaMeowView.textAttributes(
                fontSize: 30
            )
            
            // add backBarButton and set attributes
            navigationItem.backBarButtonItem = UIBarButtonItem(
                title: resources.backButtonTitle,
                style: .plain,
                target: nil,
                action: nil
            )
            navBar.tintColor = resources.darkBlueUIColor
            
            // adding action to myLikesButton and making it visible
            nyaMeowView.myLikesButton.addTarget(
                self,
                action: #selector(myLikesButtonPressed(_:)),
                for: .touchUpInside
            )
            nyaMeowView.myLikesButton.isHidden = false
            
            // adding myLikesButton to the navBar
            navBar.addSubview(nyaMeowView.myLikesButton)
            // add constraints so myLikesButton is at the same hight as the large title
            let trailingConstraint = NSLayoutConstraint(
                item: nyaMeowView.myLikesButton,
                attribute: .trailingMargin,
                relatedBy: .equal,
                toItem: navBar,
                attribute: .trailingMargin,
                multiplier: 1.0,
                constant: -16
            )
            let bottomConstraint = NSLayoutConstraint(
                item: nyaMeowView.myLikesButton,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: navBar,
                attribute: .bottom,
                multiplier: 1.0,
                constant: -6
            )
            NSLayoutConstraint.activate([trailingConstraint, bottomConstraint])
        }
    }
}
