# RedditTopPosts
Deviget challenge: show 50 top posts from Reddit.

## Objective
We would like to have you complete the following code test so we can evaluate your iOS skills.  Please place your code in a public Github repository and commit each step of your process so we can review it.

Your assignment is to create a simple Reddit client that shows the top 50 entries from [Reddit](www.reddit.com/top)

## Show your work

- ✅ Create a Public repository
- ✅ Commit each step of your process so we can follow your thought process.

## Guidelines

- ✅ Assume the latest platform and use Swift
- ✅ Use UITableView / UICollectionView to arrange the data.
- ✅ Please refrain from using any dependency manager [cocoapods / carthage / etc], instead, use URLSession 
- ✅ Support all Device Orientation
- ✅ Support all Devices screen (iPhone/iPad)
- ✅ Use Storyboards
- ✅ The app should be able to show data from each entry such as:
  - ✅Title at its full length, so take this into account when sizing your cells)
  - ✅Author
  - ✅entry date, following a format like “x hours ago” 
  - ✅A thumbnail for those who have a picture.
  - ✅Number of comments
  - ✅Unread status

- ✅In addition, for those having a picture (besides the thumbnail), please allow the user to tap on the thumbnail to be sent to the full sized picture. You don’t have to implement the IMGUR API, so just opening the URL would be OK.

## What to Include

- ✅ Pull to Refresh
- ⬜️ Pagination support: 

    Given that we're showing only the 50 top posts, I assigned low priority to this. 

    It would have higher priority if the user can load more and more posts (storing locally the posts also would become important in that case). 

    Anyway, in order to implement this, I can use the `before` and `after` query params ([link])(https://www.reddit.com/dev/api/#GET_top). I'm currently storing the id of the posts (`link` will be a better name than `post` because it would be consistent with Reddit domain names), so, I can generate the full name to use as value of `before` and `after` preprending a `"t3_"` to that id ([link](https://www.reddit.com/dev/api/#fullnames)).

    In this case, doing a pull to refresh should fetch posts before the first post known by the the app (it can happen that more that N posts were published between "pull-to-refresh"es, and in that case we don't want to miss any post); and scrolling beyond the last cell, will should fetch post after the last post known by the app.
  
- ✅ Saving pictures in the picture gallery (Handled by SFSafariViewController).
- 👷 App state-preservation/restoration.
  - ✅ Read/Unread & Dismissed posts are saved locally using UserDefaults.
  - ⬜️ Posts are not stored locally. This will be an offline mode. I assigned low priority to this because we're showing only 50 posts. It makes a lot of sense to include offline mode alongside pagination).
- ✅Indicator of unread/read post (updated status, after post it’s selected)
  - ✅ Dismiss Post Button (remove the cell from list. Animations required ✅)
  - ✅ Dismiss All Button (remove all posts. Animations required ✅)
  - ✅ Support split layout (left side: all posts / right side: detail post)

## Resources
    - [Reddit API](http://www.reddit.com/dev/api)
    - [Apigee](https://apigee.com/console/reddit)
    - Example JSON file (top.json) is listed.
    - Example Video of functionality is attached
    
## Time Spent
You do not need to fully complete the challenge. We suggest not to spend more than 5 hours total, which can be done over the course of 2 days.  Please make commits as often as possible so we can see the time you spent and please do not make one commit.  We will evaluate the code and time spent.
 
What we want to see is how well you handle yourself given the time you spend on the problem, how you think, and how you prioritize when time is insufficient to solve everything.

Please email your solution as soon as you have completed the challenge or the time is up.
