//
//  UserViewController.swift
//  majeHub
//
//  Created by Mauro Olivo on 13/02/21.
//

import UIKit
import PromiseKit
import Combine

class UserViewController: UIViewController, Storyboardable {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblJoinDate: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var reposStack: UIStackView!
    
    static var storyboardType: StoryboardType = .main
    var service = Service()
    weak var coordinator: MainCoordinator?
    var name: String?
    var user: User?
    var repos: [Repo] = []
    let loader = ImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GitHub Searcher"
        
        call()
    }
    
    func call() {
        let fetchUser: Promise<User> = service.execute(UserEndPoint(name ?? ""))
        let fetchRepos: Promise<ResponseRepos> = service.execute(ReposEndPoint(name ?? ""))
        
        scrollView.isHidden = true
        view.showAI()
        firstly {
            when(fulfilled: fetchUser, fetchRepos)
        }.done { [weak self] user, repos in
            self?.user = user
            self?.repos = repos
            self?.scrollView.isHidden = false
            self?.update()
        }.ensure { [weak self] in
            self?.view.hideAI()
        }.catch { [weak self] error in
            self?.showError()
        }
    }
    
    func update() {
        lblUsername.text = user?.login
        lblEmail.text = user?.email
        lblLocation.text = user?.location
        lblFollowers.text = "Followers: \(user?.followers ?? 0)"
        lblFollowing.text = "Following: \(user?.following ?? 0)"
        
        let df1 = DateFormatter()
        df1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = df1.date(from: user?.createdAt ?? "")
        let df2 = DateFormatter()
        df2.dateFormat = "MMM dd, yyyy"

        if date != nil {
            lblJoinDate.text = df2.string(from: date!)
        } else {
            lblJoinDate.text = ""
        }

        lblBio.text = user?.bio
        
        let url = URL(string: user?.avatarURL ?? "")
        if url != nil {
            avatar.load(url: url!)
        }

        loadRepos()
    }

    func loadRepos() {
        
        for repo in repos {
            let repoCell: RepoCell = UIView.fromNib()
            repoCell.configure(title: repo.name ?? "", forks: repo.forksCount ?? 0, stars: repo.stargazersCount ?? 0, onTap: { [weak self] in
                self?.openUrl(repo.htmlURL)
            })
            reposStack.addArrangedSubview(repoCell)
        }

    }
    
    func openUrl(_ repo: String?) {
        guard let repoURL = repo else { return }
        guard let url = URL(string: repoURL) else { return }
        UIApplication.shared.open(url)
    }
    
    func showError() {
        let alert = UIAlertController(title: "Oops...", message: "Too many requests? The Search API has a custom rate limit. You can make up to 30 requests per minute 😢", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
}
