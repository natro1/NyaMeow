//
//  NyaMeowView.swift
//  NyaMeow
//
//  Created by Natalia Rojek on 03/01/2023.
//
//  Review Pending

import UIKit

class NyaMeowView: UIView {
    
    let myLikesButton = UIButton()
    private let imageFrame = UIView()
    let catImageView = UIImageView()
    private let picOfTheDayText = UILabel()
    let saveImageButton = UIButton()
    private let didYouKnowText = UILabel()
    let factFrame = UIView()
    let randomFactLabel = UITextView()
    let likeButton = UIButton()
    private let resources = Resources()
    
    func textAttributes(fontSize: Int) -> [NSAttributedString.Key : Any] {
        let textAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.96, green: 0.78, blue: 0.92, alpha: 1.00),
            NSAttributedString.Key.strokeWidth: -2.0,
            NSAttributedString.Key.font: UIFont(name: resources.regularFontName, size: CGFloat(fontSize))!
        ] as [NSAttributedString.Key : Any]
        return textAttributes
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = resources.lightBlueColor
        setUpMyLikesButton()
        setUpImageFrame()
        setUpCatImageView()
        setUpPicOfTheDayText()
        setUpSaveImageButton()
        setUpDidYouKnowText()
        setUpFactFrame()
        setUpRandomFactLabel()
        setUpLikeButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setting up UIViews

extension NyaMeowView {
    private func setUpMyLikesButton() {
        myLikesButton.setTitle(resources.myLikesTitle, for: .normal)
        myLikesButton.setTitleColor(resources.darkBlueUIColor, for: .normal)
        myLikesButton.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        myLikesButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpImageFrame() {
        imageFrame.backgroundColor = .white
        addSubview(imageFrame)
        imageFrame.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageFrame.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 25),
            imageFrame.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            imageFrame.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -25),
            imageFrame.heightAnchor.constraint(equalToConstant: 435)
        ])
    }
    
    private func setUpCatImageView() {
        catImageView.contentMode = .scaleAspectFill
        catImageView.clipsToBounds = true
        imageFrame.addSubview(catImageView)
        catImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            catImageView.leadingAnchor.constraint(equalTo: imageFrame.leadingAnchor, constant: 35),
            catImageView.topAnchor.constraint(equalTo: imageFrame.topAnchor, constant: 35),
            catImageView.trailingAnchor.constraint(equalTo: imageFrame.trailingAnchor, constant: -35),
            catImageView.bottomAnchor.constraint(equalTo: imageFrame.bottomAnchor, constant: -85)
        ])
    }
    
    private func setUpPicOfTheDayText() {
        picOfTheDayText.text = resources.picOfTheDayText
        picOfTheDayText.font = UIFont(name: resources.picOfTheDayFontName, size: 20)
        picOfTheDayText.textColor = resources.darkBlueUIColor
        imageFrame.addSubview(picOfTheDayText)
        picOfTheDayText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picOfTheDayText.leadingAnchor.constraint(equalTo: catImageView.leadingAnchor),
            picOfTheDayText.bottomAnchor.constraint(equalTo: catImageView.topAnchor, constant: -2)
        ])
    }
    
    private func setUpSaveImageButton() {
        saveImageButton.setImage(UIImage(systemName: resources.saveIconName), for: .normal)
        saveImageButton.tintColor = resources.darkBlueUIColor
        saveImageButton.imageView?.contentMode = .scaleAspectFill
        imageFrame.addSubview(saveImageButton)
        saveImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveImageButton.topAnchor.constraint(equalTo: imageFrame.topAnchor),
            saveImageButton.trailingAnchor.constraint(equalTo: catImageView.trailingAnchor),
            saveImageButton.bottomAnchor.constraint(equalTo: catImageView.topAnchor)
        ])
    }
    
    private func setUpDidYouKnowText() {
        didYouKnowText.text = resources.didYouKnowText
        didYouKnowText.font = UIFont(name: resources.regularFontName, size: 25)
        didYouKnowText.numberOfLines = 0
        didYouKnowText.textAlignment = .center
        didYouKnowText.attributedText = NSMutableAttributedString(
            string: didYouKnowText.text!,
            attributes: textAttributes(fontSize: 30)
        )
        imageFrame.addSubview(didYouKnowText)
        didYouKnowText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            didYouKnowText.widthAnchor.constraint(equalToConstant: 250),
            didYouKnowText.topAnchor.constraint(equalTo: catImageView.bottomAnchor, constant: 10),
            didYouKnowText.centerXAnchor.constraint(equalTo: imageFrame.centerXAnchor)
        ])
    }
    
    private func setUpFactFrame() {
        factFrame.backgroundColor = resources.yellowColor
        factFrame.layer.borderColor = resources.darkBlueCGColor
        factFrame.layer.borderWidth = 1
        factFrame.layer.cornerRadius = 20
        factFrame.isHidden = true
        addSubview(factFrame)
        factFrame.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            factFrame.leadingAnchor.constraint(equalTo: imageFrame.leadingAnchor, constant: -10),
            factFrame.trailingAnchor.constraint(equalTo: imageFrame.trailingAnchor, constant: 10),
            factFrame.topAnchor.constraint(equalTo: imageFrame.bottomAnchor, constant: 20),
            factFrame.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setUpRandomFactLabel() {
        randomFactLabel.backgroundColor = .clear
        randomFactLabel.showsVerticalScrollIndicator = false
        randomFactLabel.isEditable = false
        randomFactLabel.textAlignment = .center
        randomFactLabel.textColor = UIColor(red: 0.96, green: 0.78, blue: 0.92, alpha: 1.00)
        randomFactLabel.font = UIFont(name: resources.regularFontName, size: 20)
        addSubview(randomFactLabel)
        randomFactLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            randomFactLabel.leadingAnchor.constraint(equalTo: factFrame.leadingAnchor, constant: 10),
                randomFactLabel.trailingAnchor.constraint(equalTo: factFrame.trailingAnchor, constant: -10),
                randomFactLabel.topAnchor.constraint(equalTo: factFrame.topAnchor, constant: 10),
                randomFactLabel.bottomAnchor.constraint(equalTo: factFrame.bottomAnchor, constant: -10)
        ])
    }
    
    private func setUpLikeButton() {
        likeButton.setImage(UIImage(named: resources.emptyHeartIcon), for: .normal)
        likeButton.setImage(UIImage(named: resources.emptyHeartIcon), for: .highlighted)
        addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.centerXAnchor.constraint(equalTo: imageFrame.centerXAnchor),
            likeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}
