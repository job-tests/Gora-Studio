//
//  NewsCollectionViewCell.swift
//  GORA_TestTask
//
//  Created by Kirill Drozdov on 13.06.2022.
//

import Foundation
import Kingfisher

class NewsCollectionViewCell: UICollectionViewCell, CreteNib {

    // MARK: - @IBOutlels
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var gradientView: UIView!

    static let identifier = "NewCollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        newImage.addSubview(gradientView)
        newImage.bringSubviewToFront(gradientView)
    }

    // MARK: - Configure cells with data method
    func setupCells(from article: Article) {
        newLabel.text = article.title
        newImage.kf.setImage(with: URL(string: article.urlToImage ?? ""))
    }

}

