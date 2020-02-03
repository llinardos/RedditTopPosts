import UIKit

class PostsListVC: UIViewController {
  @IBOutlet private var tableView: UITableView!
  
  var onGoToDetail: () -> Void = {} // TODO: replace with onPostSelected: (Post) -> Void
  var posts: [RedditPost] = [
    RedditPost(title: "Title 1", authorName: "Author 1", commentsCount: 100, creationDate: Date()),
    RedditPost(title: "Title 2", authorName: "Author 2", commentsCount: 100000, creationDate: Date().advanced(by: -30)),
    RedditPost(title: "Title 3", authorName: "Author 3", commentsCount: 1241, creationDate: Date().advanced(by: -121)),
    RedditPost(title: "Title 4", authorName: "Author 4", commentsCount: 125125412341, creationDate: Date().advanced(by: -1241231)),
  ]
  
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
    
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fireGoToDetail)))
  }
  
  @objc
  private func fireGoToDetail() {
    onGoToDetail()
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
}
