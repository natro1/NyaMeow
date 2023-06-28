//
//  LikesView.swift
//  NyaMeow
//
//  Created by Natalia Rojek on 24/01/2023.
//
//  Review Pending

import UIKit

class LikesView: UIView {
    
    let likeTableView = UITableView()
    private let resources = Resources()
    
    func createDeleteButton() -> UIButton {
        // creating delete button
        let deleteButton = UIButton()
        // set up its frame
        deleteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        // set up its image as trash icon
        deleteButton.setImage(UIImage(systemName: resources.trashIcon), for: .normal)
        return deleteButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(likeTableView)
        // adding cells to the tableview and setting its background color
        likeTableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        likeTableView.backgroundColor = UIColor(red: 0.80, green: 0.94, blue: 0.92, alpha: 1)
        backgroundColor = UIColor(red: 0.80, green: 0.94, blue: 0.92, alpha: 1)
        
        // tableview's constraints
        likeTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            likeTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            likeTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            likeTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
