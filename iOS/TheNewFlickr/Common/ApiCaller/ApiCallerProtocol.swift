//
//  ApiCallerProtocol.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 26/09/2021.
//

import Foundation

protocol ApiCallerProtocol: AnyObject {
    
    var updateLoadingStatus: (()->())? { get set }
    var updateError: ((String)->())? { get set }
    var state: State { get set }
    
    func startRequest<M: Codable>(api: ApiHandlerProtocol,
                                  request: Requestable,
                                  mappingClass: M.Type,
                                  successCompletion: @escaping((M?) -> Void),
                                  showLoading: Bool)
}
