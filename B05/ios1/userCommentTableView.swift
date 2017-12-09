//
//  userComment.swift
//  ios1
//
//  Created by maartenwei on 2017/11/11.
//  Copyright © 2017年 Niguai. All rights reserved.
//

import UIKit

class userCommentTableView: UITableViewController {

    var userCommentArray = [userComment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        userCommentArray.removeAll()
        self.tableView.reloadData()
        let urlStr = "http:140.136.150.95:3000/comment/show/user?userID=\(AccountData.user_ID)".addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        let url = URL(string:urlStr!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            if let data = data, let dic = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]]{
                DispatchQueue.main.async {
                    for commentData in dic {
                        
                        let commentObj = userComment(ID: commentData["ID"] as! Int,
                                                     create_UserID: commentData["create_UserID"] as! Int,
                                                     StoreID: commentData["storeID"] as! Int,
                                                     storeName: commentData["Name"] as! String,
                                                     Memo: commentData["Memo"] as! String,
                                                     Score: commentData["Score"] as! Double,
                                                     Score_Envir: commentData["Score_Envir"] as! Double,
                                                     Score_Taste: commentData["Score_Taste"] as! Double,
                                                     Score_Service: commentData["Score_Service"] as! Double
                            
                        );
                        self.userCommentArray.append(commentObj);
                        
                    }
                    
                    self.tableView.reloadData()
                }
            }
            
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85.0;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userCommentArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = userCommentArray[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCommentCell", for: indexPath) as! userCommentCell
        
        cell.storeName.text = "\(comment.storeName)"
        cell.storeStar.rating = comment.Score
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == UITableViewCellEditingStyle.delete{
            let urlStr = "http:140.136.150.95:3000/comment/delete?commentID=\(userCommentArray[indexPath.row].ID)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlStr!)
            let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
                if let data = data, let _ = String(data: data, encoding: .utf8) {
                    
                }
            }
            task.resume()
            
            userCommentArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
    }
    
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showComment" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! userShowComment
                destinationController.showCommentDataArray = userCommentArray[indexPath.row]
            }
        }
    }
    

}
