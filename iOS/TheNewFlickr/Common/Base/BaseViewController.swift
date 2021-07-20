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
    
    func showActivityIndicator() -> UIActivityIndicatorView {
        view.isUserInteractionEnabled = false
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = #colorLiteral(red: 0.9215686275, green: 0.2078431373, blue: 0.4941176471, alpha: 1)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        return activityIndicator
    }

    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
    }
    
    func loadViewFromStoryboard<T>(viewControllerType: T.Type) -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing:T.self)) as! T
    }
    
}

