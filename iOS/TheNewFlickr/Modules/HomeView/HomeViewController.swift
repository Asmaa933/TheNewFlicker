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
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
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
    
    @objc func endEditing() {
        view.endEditing(true)
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
            return CGSize(width: width / 2 , height: 130)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchInArray(searchText: searchText)
    }
    
}
