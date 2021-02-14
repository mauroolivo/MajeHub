import UIKit
import SwiftUI

class MainCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

extension MainCoordinator {
    
    func start() {
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
        push(vc)
    }

    func showDetail(_ name: String) {
        let vc = UserViewController.instantiate()
        vc.coordinator = self
        vc.name = name
        push(vc)
    }
    
}


