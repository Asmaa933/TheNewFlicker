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
        viewModel.getSearchList()
    }
    
    func setupView() {
        registerCells()
    }
    
    func registerCells() {
        collectionView.registerCellNib(cellClass: HomeCell.self)
        collectionView.registerCellNib(cellClass: ActivityIndicatorCell.self)
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let _ = cell as? ActivityIndicatorCell {
            viewModel.getSearchList()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.hasMoreItems {
            return viewModel.searchArray.count + 1
        } else {
            return viewModel.searchArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.hasMoreItems && indexPath.row == viewModel.searchArray.count {
            let cell = collectionView.dequeue(indexPath: indexPath) as ActivityIndicatorCell
            return cell
        } else {
            let cell = collectionView.dequeue(indexPath: indexPath) as HomeCell
            cell.configureCell(photo: viewModel.searchArray[indexPath.row])
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        if viewModel.hasMoreItems && indexPath.row == viewModel.searchArray.count {
            return CGSize(width: width, height: 50)
        }else {
            return CGSize(width: width / 2 , height: 130)
        }
    }
}
