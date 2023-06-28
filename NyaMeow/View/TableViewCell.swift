//
//  TableViewCell.swift
//  NyaMeow
//
//  Created by Natalia Rojek on 07/05/2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // numberOfLines = 0 so the cell will display all the text no matter how long it is
        textLabel?.numberOfLines = 0
        // set background color of the cell
        backgroundColor = UIColor(red: 0.80, green: 0.94, blue: 0.92, alpha: 1)
        // disable cell selection
        selectionStyle = .none
        // set the color of buttons inside the cell
        tintColor = UIColor(red: 0.62, green: 0.76, blue: 0.74, alpha: 1.00)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
