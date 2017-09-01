//
//  SViewController.swift
//  KaraokeApp
//
//  Created by Kishore Baskar on 7/25/17.
//  Copyright © 2017 Kishore Baskar. All rights reserved.
//

import UIKit

class SViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var table: UITableView!
    @IBOutlet var searchField: UITextField!
    let youtubeAPIurl = "https://www.googleapis.com/youtube/v3/search?part=snippet&"
    let apikey = "&maxResults=10&key=AIzaSyBdC6KK5st6rSkVYKYNNRXN5eTnhdDGcFk"
    
    var searchReturns = [SearchResultsClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell
      
        
            let searchObject = searchReturns[indexPath.row]
        
            cell!.title.text = searchObject.name
            cell!.length.text = searchObject.time
            let url = URL(string: searchObject.thumbnailLink)
            let data = try? Data(contentsOf: url!)
        
            if data != nil {
                
                let image = UIImage(data: data!)
                cell!.thumbnail.image = image
            }
        return cell!

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchReturns.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func unwindToHere(_segue: UIStoryboardSegue)
    {
        
    }
    
    
    @IBAction func endEdit(_ sender: Any) {
        searchField.resignFirstResponder()
        var swifty : JSON?
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let text = searchField.text!
        let textUpdated = text.replacingOccurrences(of: " ", with: "+")
        let urls = youtubeAPIurl + "q=" + textUpdated + apikey
        let request = URLRequest(url: URL(string: urls)!)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
            
            
            if let data = receivedData {
                // no do-catch since no errors thrown
                swifty = JSON(data)
                
                
                let searchDict = swifty?["items"]
                self.searchReturns = [SearchResultsClass]()
                for (_, value):(String, JSON) in searchDict!
                {
                    let url = value["id"]["videoId"].string
                    let title = value["snippet"]["title"].string
                    let channelTitle = value["snippet"]["channelTitle"].string
                    let thumbnailLink = value["snippet"]["thumbnails"]["default"]["url"].string
                    
                        self.searchReturns.append(SearchResultsClass(name : title!, time : channelTitle!, thumbnailLink : thumbnailLink!, urlId : url!))
                    
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                }
                
                
            }
            self.table.reloadData()
        }
        task.resume()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "ToVideo")
        {
            let destVC = segue.destination as? YoutubeViewController
            destVC?.dataFromTable = searchReturns[(self.table.indexPathForSelectedRow?.row)!]
        }
    }
    

}
