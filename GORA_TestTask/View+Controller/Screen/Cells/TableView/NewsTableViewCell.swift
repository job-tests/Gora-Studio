//
//  NewsTableVCell.swift
//  GORA_TestTask
//
//  Created by Kirill Drozdov on 13.06.2022.
//

import UIKit
import SafariServices

protocol CreteNib {
    static func nib() -> UINib
}

protocol SafariDelegate: AnyObject {
    func openSafari(safariURL url: URL)
}

class NewsTableVCell: UITableViewCell, CreteNib {

    static let identifier = "NewTableViewCell"

    weak var delegate: SafariDelegate?

    var news: News?

    @IBOutlet weak var collectionView: UICollectionView!

    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(NewsCollectionViewCell.nib(), forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension NewsTableVCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier,for: indexPath) as? NewsCollectionViewCell, let new = news?.articles?[indexPath.row]
        else {
            return UICollectionViewCell()
        }
        cell.setupCells(from: new)
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news?.articles?.count ?? 0
    }

}

extension NewsTableVCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: news?.articles?[indexPath.row].url ?? "") {
            delegate?.openSafari(safariURL: url)
        }
    }
}

extension NewsTableVCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
