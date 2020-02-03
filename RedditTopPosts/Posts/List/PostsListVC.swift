import UIKit

class PostsListVC: UIViewController {
  @IBOutlet private var tableView: UITableView!
  
  var onPostSelected: (RedditPost) -> Void = { _ in }
  var posts: [RedditPost] = []
  
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
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tableView.indexPathForSelectedRow.map {
      self.tableView.deselectRow(at: $0, animated: true)
    }
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
