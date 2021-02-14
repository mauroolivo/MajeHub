//
//  RepoCell.swift
//  majeHub
//
//  Created by Mauro Olivo on 13/02/21.
//


import UIKit

class RepoCell: UIView {
    

    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var lblForks: UILabel!
    @IBOutlet weak var lblStars: UILabel!
    
    var onTap: (()->())?
    
    func configure(title: String, forks: Int, stars: Int, onTap: @escaping (()->()) ){
        
        lblTitle.text = title
        lblForks.text = "Forks: \(forks)"
        lblStars.text = "Stars: \(stars)"
        self.onTap = onTap
    }
    
    @IBAction func onTapBtn(_ sender: Any) {
        self.onTap?()
    }
    
}
