import UIKit

class PostsListVC: UIViewController {
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var errorView: UIView!
  @IBOutlet weak var loadingView: UIView!
  
  @IBOutlet private var tableView: UITableView!
  
  var onPostSelected: (RedditPost) -> Void = { _ in }
  private var posts: [RedditPost] = []
  var getPosts: (@escaping (Result<[RedditPost], Error>) -> Void) -> Void = { _ in }
  
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
    
    errorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fetchPosts)))
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.tableView.indexPathForSelectedRow.map {
      self.tableView.deselectRow(at: $0, animated: true)
    }
    
    if posts.count == 0 {
      self.fetchPosts()
    }
  }
  
  @objc
  private func fetchPosts() {
    self.showLoading()
    self.getPosts() { [unowned self] result in
      switch result {
      case .success(let posts): self.showPosts(posts)
      case .failure(let error): self.showError(error)
      }
    }
  }
  
  private func showLoading() {
    self.loadingView.isHidden = false
    self.contentView.isHidden = true
    self.errorView.isHidden = true
  }
  
  private func showPosts(_ posts: [RedditPost]) {
    self.loadingView.isHidden = true
    self.contentView.isHidden = false
    self.errorView.isHidden = true

    self.posts = posts
    self.tableView.reloadData()
  }
  
  private func showError(_ error: Error) {
    self.loadingView.isHidden = true
    self.contentView.isHidden = true
    self.errorView.isHidden = false
  }
}

extension PostsListVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let post = posts[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
    cell.setPost(post)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedPost = posts[indexPath.row]
    onPostSelected(selectedPost)
  }
}
