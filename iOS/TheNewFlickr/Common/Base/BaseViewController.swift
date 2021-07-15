//
//  BaseViewController.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 15/07/2021.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var activityInicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupViewModel(viewModel: BaseViewModel) {
        viewModel.updateLoadingStatus = {[weak self] in
            guard let self = self else {return}
            switch viewModel.state {
            case .loading:
                self.activityInicator = self.showActivityIndicator()
            case .empty, .error,.populated:
                self.removeActivityIndicator(activityIndicator: self.activityInicator)
            }
        }
        
        viewModel.updateError = { [weak self] error in
            self?.showAlert(message: error)
        }
        
        viewModel.checkInternetConnection = {[weak self] in
            self?.showAlert(message: ErrorHandler.noInternetConnection.rawValue)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default)
        alert.addAction(action)
        DispatchQueue.main.async {[weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    func showActivityIndicator() -> UIActivityIndicatorView{
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        return activityIndicator
    }

    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
    }
}

