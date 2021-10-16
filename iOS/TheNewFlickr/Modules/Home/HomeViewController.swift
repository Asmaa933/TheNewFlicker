//
//  HomeViewController.swift
//  TheNewFlickr
//
//  Created by Abdoelrhman Eaita on 13/07/2021.
//

import UIKit
import PromiseKit

class HomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var cachedTableView: UITableView!

    // MARK: - Variables
    private(set) var viewModel: HomeViewModelProtocol = HomeViewModel()
    private let refreshControl = UIRefreshControl()
    private var loaderIndicator: UIActivityIndicatorView?

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
    }

    // MARK: - Actions
    @IBAction private func clearAction(_ sender: UIButton) {
        viewModel.removeSearchHistory()
    }
}
// MARK: - Helper Methods
fileprivate extension HomeViewController {

    func setupViewModel() {
        viewModel.apiCaller.updateLoadingStatus = {[weak self] in
            self?.handleLoadingState()
        }

        viewModel.apiCaller.updateError = {[weak self] message in
            self?.showAlert(message: message)
        }

        viewModel.didSelectPhoto = {[weak self] photo in
            self?.showDetails(photo: photo)
        }

        viewModel.reloadTableView = {[weak self] in
            self?.setupSearchView()
        }

        viewModel.fetchSearchList()
    }

    func handleLoadingState() {
        switch viewModel.apiCaller.state {
        case .loading:
            loaderIndicator = showLoading(view: collectionView)
        case .populated:
            removeLoading(loaderIndicator, from: collectionView)
            notifyDataFetched()
            loaderIndicator = nil
        case .empty, .error:
            removeLoading(loaderIndicator, from: collectionView)
            loaderIndicator = nil
        }
    }

    func notifyDataFetched() {
        refreshControl.endRefreshing()
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    func setupView() {
        registerCells()
        setupSearchBar()
        addTapGestureToView()
        setupRefreshControl()
        searchView.isHidden = true
    }

    func registerCells() {
        collectionView.registerCellNib(cellClass: HomeCell.self)
        collectionView.registerCellNib(cellClass: ActivityIndicatorCell.self)
        cachedTableView.registerCellNib(cellClass: SearchCell.self)
    }

    func setupSearchBar() {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }

    func addTapGestureToView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func setupSearchView() {
        cachedTableView.reloadData()
        if viewModel.cachedSearchArray.isEmpty {
            searchView.isHidden = true
        } else {
            searchView.isHidden = false
            cachedTableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                        at: .top,
                                        animated: false)
        }
    }

    @objc func endEditing() {
        view.endEditing(true)
        searchView.isHidden = true
        searchBar.showsCancelButton = false
    }

    func setupRefreshControl() {
        refreshControl.tintColor = .darkText
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }

    @objc func reload() {
        viewModel.fetchSearchList()
    }

    func showDetails(photo: Photo) {
        let details = loadViewFromStoryboard(viewControllerType: DetailsViewController.self)
        details.viewModel = DetailsViewModel(selectedPhoto: photo)
        navigationController?.pushViewController(details, animated: true)
    }
}

// MARK: - UICollectionView Protocols Imp.
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectPhoto(at: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let _ = cell as? ActivityIndicatorCell {
            viewModel.fetchSearchList()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = viewModel.getPhotosCount()
        if count == 0 && loaderIndicator == nil {
            collectionView.setEmptyView(with: #imageLiteral(resourceName: "notfound"), title: "Nothing Found")
        } else if viewModel.hasMoreItems && !viewModel.isSearch {
            count += 1
            collectionView.restore()
        } else {
            collectionView.restore()
        }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if viewModel.hasMoreItems && indexPath.row == viewModel.getPhotosCount() && !viewModel.isSearch {
            let cell = collectionView.dequeue(indexPath: indexPath) as ActivityIndicatorCell
            return cell
        } else {
            let cell = collectionView.dequeue(indexPath: indexPath) as HomeCell
            cell.configureCell(photo: viewModel.getPhoto(at: indexPath.row))
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        if viewModel.hasMoreItems && indexPath.row == viewModel.getPhotosCount() && !viewModel.isSearch {
            return CGSize(width: width, height: 50)
        } else {
            return CGSize(width: width / 2 - 7.5, height: 130)
        }
    }
}

// MARK: - UISearchBarDelegate Protocol Imp.

extension HomeViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchView.isHidden = true
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        viewModel.getCachedSearch()
        searchView.isHidden = !(searchBar.text?.isEmpty ?? false)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if viewModel.cachedSearchArray.isEmpty {
            searchView.isHidden = true
        } else {
            searchView.isHidden = !searchText.isEmpty
        }

        viewModel.searchInArray(searchText: searchText)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.saveSearchResult(searchText: searchBar.text ?? "")
    }
}

// MARK: - UITableView Protocols Imp.

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchText = viewModel.cachedSearchArray[indexPath.row].item
        searchBar.text = searchText
        viewModel.searchInArray(searchText: searchText ?? "")
        searchView.isHidden = true
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cachedSearchArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SearchCell
        cell.index = indexPath.row
        cell.text = viewModel.cachedSearchArray[indexPath.row].item
        return cell
    }
}

extension HomeViewController: LoadingProtocol {}

extension HomeViewController: AlertProtocol {}
