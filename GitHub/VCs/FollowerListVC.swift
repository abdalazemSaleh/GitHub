//
//  FollowerListVC.swift
//  GitHub
//
//  Created by Abdalazem Saleh on 2022-09-15.
//

import UIKit

protocol followerListVCDelegate: AnyObject {
    func requestFollower(for username: String)
}

class FollowerListVC: GFDataLoadingVC {
    
    enum Section {
    case main
    }
    
    // MARK: - Variables
    var userName: String!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    var followers: [Follower]           = []
    var filteredFollowers: [Follower]   = []
    var page                            = 1
    var hasMoreFollowers                = true
    var isSearching                     = false
    
    // MARK: - Init
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.userName = username
        title         = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureSearchController()
        configureViewController()
        getFollowers(username: userName, page: page)
        configureDataSource()
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Configure functions
    /// Configure View Controller
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTaped))
        navigationItem.rightBarButtonItem = addButton
    }
    /// Configure collection view
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: HelperUI.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate         = self
        collectionView.backgroundColor  = .systemBackground
        collectionView.register( FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.cellID)
    }
    /// Configure data source
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.cellID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    /// Configure search controller
    func configureSearchController() {
        let searchController                                    = UISearchController()
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.delegate                     = self
        searchController.searchBar.placeholder                  = "Search for username "
        searchController.obscuresBackgroundDuringPresentation   = false
        navigationItem.searchController                         = searchController
    }
    
    // MARK: - Functions
    @objc func addButtonTaped() {
        showLoadingView()
        
        NetworkManger.share.getUserInfo(for: userName) { [weak self] result in
            guard let self = self else { return }
            self.dismisLoadingView()

            switch result {
            case.success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)

                PersitenceManger.updateWith(favorite: favorite, actionType: .add) { myError in
//                    guard let self = self else { return }
                    guard let error = myError else {
                        self.presentGFAlert(title: "Success!", message: "You have successfuly favorited this user.🎉", buttonTitle: "OK")
                        return
                    }
                    self.presentGFAlert(title: "Some thing went wrong", message: error.rawValue, buttonTitle: "OK")
                }
            case.failure(let error):
                self.presentGFAlert(title: "Some thing went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
        
    }
    
    // MARK: - Network call
    /// Get followers
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManger.share.getFollowers(for: userName, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismisLoadingView()

            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                
                if self.followers.isEmpty {
                    let message = "This user doesn't have any follower 😔."
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                    return
                }
                    
                self.updateData(on: followers)
            case .failure(let error):
                self.presentGFAlert(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    /// Update data
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true)  }
    }
}

// MARK: - UICollection view delegate extention
@available(iOS 16.0, *)
extension FollowerListVC: UICollectionViewDelegate {
    /// Load more followers
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: userName, page: page)
        }
    }
    
    /// Did select item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray     = isSearching ? filteredFollowers : followers
        let follower        = activeArray[indexPath.item]
        
        let VC              = UserInfoVC()
        VC.username         = follower.login
        VC.delegate          = self
        
        let navController   = UINavigationController(rootViewController: VC)
        present(navController, animated: true)
        
    }
}

// MARK: - Search controller delegate
extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
}
// MARK: - Follower list vc delegate
extension FollowerListVC: followerListVCDelegate {
    
    func requestFollower(for username: String) {
        // Get follower for username
        self.userName   = username
        title           = username
        page            = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
}
