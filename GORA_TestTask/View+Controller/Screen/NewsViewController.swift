//
//  NewsViewController.swift
//  GORA_TestTask
//
//  Created by Kirill Drozdov on 13.06.2022.
//


import Foundation
import SafariServices

class NewsViewController: UIViewController {

    private var news:[NewsCategories: News] = [:]
    private var sortedCategories: [NewsCategories] {
        return Set(filteredNews.keys).sorted(by: { $0.title < $1.title })
    }
    private var filteredNews = [NewsCategories: News]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupConstraints()
        setupTableView()
        NetworkManager.shared?.fetchNews { [unowned self] news in
            self.news = news
            self.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }

    private let table: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.separatorStyle = .none
        table.backgroundColor = .systemGray6
        table.allowsSelection = false
        table.showsVerticalScrollIndicator = false
        return table
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        return indicator
    }()


    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.searchBar.placeholder = "Найти новость"
        return sc
    }()

    private func setupNavigationBar() {
        self.title = "Свежие новости"
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
    }


    private func setupTableView() {
        table.register(NewsTableVCell.nib(), forCellReuseIdentifier: NewsTableVCell.identifier)
        table.dataSource = self
        table.delegate = self
    }


    private func setupConstraints() {
        [table, activityIndicator].forEach(view.addSubview(_:))

        table.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            table.heightAnchor.constraint(equalTo: view.heightAnchor),
            table.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        activityIndicator.frame = view.bounds
    }


    private func useFilter() {
        filteredNews = news.compactMapValues { new -> News? in
            guard let articles = new.articles else { return nil }
            let filteredArticles = articles.filter { article in
                guard let title = article.title, let description = article.description, let searchText = searchController.searchBar.text else {return false}
                let result = searchText.isEmpty || title.localizedCaseInsensitiveContains(searchText) || description.localizedCaseInsensitiveContains(searchText)
                return result
            }
            if !filteredArticles.isEmpty {
                return News(articles: filteredArticles)
            }
            return nil
        }
    }

    private func reloadData() {
        useFilter()
        table.reloadData()
    }

}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableVCell.identifier,for: indexPath) as? NewsTableVCell else { return UITableViewCell()}
        let category = sortedCategories[indexPath.section]
        cell.news = filteredNews[category]
        cell.delegate = self
        cell.collectionView.reloadData()
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredNews.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedCategories[section].title
    }
}


extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 23) 
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .left
    }

}

extension NewsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        reloadData()
    }
}

extension NewsViewController: SafariDelegate {
    func openSafari(safariURL url: URL) {
        let vc = SFSafariViewController(url: url)
        vc.delegate = self
        self.present(vc, animated: true)
    }
}

extension NewsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
