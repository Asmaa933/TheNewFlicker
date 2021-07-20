//
//  HomeViewController.swift
//  TheNewFlickr
//
//  Created by Abdoelrhman Eaita on 13/07/2021.
//

import UIKit
import PromiseKit


class HomeViewController: BaseViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var cachedTableView: UITableView!
    
    private(set) var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
    }
    
    @IBAction private func clearAction(_ sender: UIButton) {
        viewModel.removeSearchHistory()
    }
}

fileprivate extension HomeViewController {
    
    func setupViewModel() {
        setupViewModel(viewModel: viewModel)
        
        viewModel.reloadCollectionView = {[weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.didSelectPhoto = {photo in
            print(photo.title ?? "")
        }
        
        viewModel.reloadTableView = {[weak self] in
            self?.setupSearchView()
        }
        
        viewModel.getSearchList()
    }
    
    func setupView() {
        registerCells()
        setupSearchBar()
        addTapGestureToView()
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
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectPhoto(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let _ = cell as? ActivityIndicatorCell {
            viewModel.getSearchList()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if viewModel.hasMoreItems && !viewModel.isSearch {
            return viewModel.getPhotosCount() + 1
        } else {
            return viewModel.getPhotosCount()
        }
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
        }else {
            return CGSize(width: width / 2 - 7.5, height: 130)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchView.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.getCachedSearch()
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchView.isHidden = !searchText.isEmpty
        viewModel.searchInArray(searchText: searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.saveSearchResult(searchText: searchBar.text ?? "")
    }
}

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
