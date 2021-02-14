//
//  ViewController.swift
//  FreeNba
//
//  Created by Mauro Olivo on 12/02/21.
//

import UIKit
import PromiseKit
import Combine

class HomeViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var subscribers = Set<AnyCancellable>()
    
    static var storyboardType: StoryboardType = .main
    var service = Service()
    weak var coordinator: MainCoordinator?
    var users: [User] = []
    
    let loader = ImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GitHub Searcher"
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: textField)
            .sink { (notification) in
                self.call()
            }.store(in: &subscribers)
        
        call()
    }
    
    func call() {
        if (self.textField.text ?? "").isEmpty {
            callUsers()
        } else {
            callSearchUsers()
        }
    }

    
    func callUsers() {
        view.showAI()
        service.execute(UsersEndPoint())
            .done { [weak self] (result: ResponseUsers) in
                self?.view.hideAI()
                self?.users = result
                self?.tableView.reloadData()

            }.catch { [weak self] (error: Error) in
                self?.view.hideAI()
                self?.showError()
            }

    }
    
    func callSearchUsers() {
        view.showAI()
        service.execute(SearchUsersEndPoint(self.textField.text ?? ""))
            .done { [weak self] (result: ResponseSearchUsers) in
                self?.view.hideAI()
                self?.users = result.items
                self?.tableView.reloadData()
                
            }.catch { [weak self] (error: Error) in
                self?.view.hideAI()
                self?.showError()
            }
        
    }
    
    func showError() {
        let alert = UIAlertController(title: "Oops...", message: "Too many requests? The Search API has a custom rate limit. You can make up to 30 requests per minute 😢", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell {
            
            let user = users[indexPath.row]
            cell.configure(user)
            
            if let url = URL(string: user.avatarURL ?? "") {
                let token = loader.loadImage(url) { result in
                    do {
                        let image = try result.get()
                        DispatchQueue.main.async {
                            cell.cellImageView.image = image
                        }
                    } catch {}
                }
                cell.onReuse = {
                    if let token = token {
                        self.loader.cancelLoad(token)
                    }
                }
            }

            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        let user = users[indexPath.row]
        coordinator?.showDetail(user.login)
    }
    
}
