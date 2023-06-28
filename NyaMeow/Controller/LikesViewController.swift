//
//  LikesViewController.swift
//  NyaMeow
//
//  Created by Natalia Rojek on 24/01/2023.
//
//  Review Pending

import UIKit

class LikesViewController: UIViewController {
    
    private let likesView = LikesView()
    private var likeArray = DataService.shared.getLikes()
    private let resources = Resources()

    override func viewDidLoad() {
        super.viewDidLoad()
        // setting up a view in LikesView
        view = likesView
        // changing the title in navigation bar so its not large anymore
        navigationController?.navigationBar.prefersLargeTitles = false
        title = resources.myLikesTitle
        likesView.likeTableView.dataSource = self
    }
}

// MARK: - TableView

extension LikesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // setting the number of rows in a tableView as the count of likeArray
        return likeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // creating a single cell in a tableview
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath)
        // add delete button into the cell
        let deleteButton = likesView.createDeleteButton()
        cell.accessoryView = deleteButton
        // set a tag = indexPath.row to the button so we can later use indexPath outside this function
        deleteButton.tag = indexPath.row
        // adding action to deleteButton
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed(sender:)), for: .touchUpInside)
        // set the text inside a label in the cell
        cell.textLabel?.text = likeArray[indexPath.row].fact
        return cell
    }
}

// MARK: - Delete data from tableview

extension LikesViewController {
    
    @objc private func deleteButtonPressed(sender: UIButton) {
        // getting current row of deleted cell from indexPath.row thansk to the tag
        let currentRow = sender.tag
        // creating a nyaMeowViewController so we can use its functions
        let nyaMeowViewController = navigationController?.viewControllers.first as? NyaMeowViewController
        // calling a function from nyaMeowViewController to compare likes
        // we have to check if the like that we deleted here isnt liked (by a <3 button) in the first VC
        nyaMeowViewController?.compareAndDeleteLike(likeText: likeArray[currentRow].fact)
        // delete the like from database
        DataService.shared.deleteLike(at: currentRow)
        // delete it from likeArray
        likeArray.remove(at: currentRow)
        // update the tableview
        likesView.likeTableView.reloadData()
    }
}
