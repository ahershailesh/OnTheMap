//
//  StudentTableViewCell.swift
//  OnTheMap
//
//  Created by Shailesh Aher on 1/14/18.
//  Copyright © 2018 Shailesh Aher. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var link: UILabel!
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var shortFormLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAttribute()
    }
    
    var student : Student? {
        didSet {
            title.text = student?.fullName ?? "-"
            subTitle.text = student?.mapString ?? "-"
            link.text = student?.mediaURL ?? "-"
            shortFormLabel.text = student?.shortForm.uppercased() ?? "-"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        subTitle.text = nil
        link.text = nil
        shortFormLabel.text = nil
    }
    
    private func setAttribute() {
        let randomColor = UIColor.random
        photoView.backgroundColor = randomColor
        shortFormLabel.textColor = randomColor.isLight() ? UIColor.black : UIColor.white
        photoView.layer.cornerRadius = photoView.frame.width/2
        
    }
}
