//
//  NetworkMonitor.swift
//  TheNewFlickr
//
//  Created by Asmaa Tarek on 15/07/2021.
//

import UIKit
import Network

class NetworkMonitor {
    static public let shared = NetworkMonitor()
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    var netOn: Bool = true

    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }

    func startMonitoring() {
        self.monitor.pathUpdateHandler = {[weak self] path in
            guard let self = self else {return}
            self.netOn = path.status == .satisfied
        }
    }

    func stopMonitoring() {
        self.monitor.cancel()
    }
}
