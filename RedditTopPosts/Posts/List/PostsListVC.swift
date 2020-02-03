import UIKit

class PostsListVC: UIViewController {
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var errorView: UIView!
  @IBOutlet weak var loadingView: UIView!
  
  @IBOutlet private var tableView: UITableView!
  private var refreshControl = UIRefreshControl()
  @IBOutlet private var dismissAllButton: UIBarButtonItem!
  
  var onPostSelected: (RedditPost) -> Void = { _ in }
  var posts: Posts! // TODO: should be initialized with production ready implementation
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Reddit Posts"
    
    self.view.backgroundColor = .black
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    self.tableView.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
    
    self.tableView.tableFooterView = UIView()
    self.tableView.backgroundColor = self.view.backgroundColor
    
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 44
    
    self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    self.tableView.separatorColor = .white
    
    self.refreshControl.tintColor = UIColor.systemOrange
    self.refreshControl.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
    self.tableView.addSubview(refreshControl)
    
    errorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fetchPosts)))
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.tableView.indexPathForSelectedRow.map {
      self.tableView.deselectRow(at: $0, animated: true)
    }
    
    if posts.toShow().isEmpty {
      self.fetchPosts()
    }
  }
  
  @objc
  private func fetchPosts() {
    if !refreshControl.isRefreshing {
      self.showLoading()
    }
    self.posts.fetch() { [weak self] result in
      guard let self = self else { return }
      self.refreshControl.endRefreshing()
      switch result {
      case .success: self.showPosts()
      case .failure(let error): self.showError(error)
      }
    }
  }
  
  private func showLoading() {
    self.loadingView.isHidden = false
    self.contentView.isHidden = true
    self.errorView.isHidden = true
    
    self.dismissAllButton.isEnabled = false
  }
  
  private func showPosts() {
    self.loadingView.isHidden = true
    self.contentView.isHidden = false
    self.errorView.isHidden = true
    
    self.dismissAllButton.isEnabled = true

    self.tableView.reloadData()
  }
  
  private func showError(_ error: Error) {
    self.loadingView.isHidden = true
    self.contentView.isHidden = true
    self.errorView.isHidden = false
    
    self.dismissAllButton.isEnabled = false
  }
  
  private func dismissPost(_ post: RedditPost) {
    guard let indexPath = self.posts.toShow().firstIndex(of: post).map({ IndexPath(row: $0, section: 0) }) else {
      return
    }
    self.posts.dismiss(post)
    self.tableView.deleteRows(at: [indexPath], with: .left)
  }
  
  private func dismissAllPosts() {
    self.posts.dismissAll()
    
    let allIndexPaths = (0..<self.tableView.numberOfRows(inSection: 0)).enumerated().map {
      return IndexPath(row: $0.offset, section: 0)
    }
    self.posts.dismissAll()
    self.tableView.deleteRows(at: allIndexPaths, with: .left)
  }
  
  @IBAction private func onDismissAllTap(_ sender: UIBarButtonItem) {
    self.dismissAllPosts()
  }
}

extension PostsListVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.toShow().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let post = posts.toShow()[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
    cell.showPost(post, asRead: posts.isPostRead(post))
    cell.onDismiss = { [weak self] in
      self?.dismissPost(post)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedPost = posts.toShow()[indexPath.row]
    posts.markAsRead(selectedPost)
    tableView.reloadRows(at: [indexPath], with: .none)
    onPostSelected(selectedPost)
  }
}
