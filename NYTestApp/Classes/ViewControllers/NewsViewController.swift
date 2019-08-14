//
//  NewsViewController.swift
//  NYTestApp
//
//  Created by Hariharan jaganathan on 12/08/19.
//  Copyright © 2019 Hariharan jaganathan. All rights reserved.
//

import UIKit

let kEstimatedNewsRableRowHeight:CGFloat = 100.0

class NewsViewController: UIViewController {

    @IBOutlet weak var articleTableView:UITableView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!

    var dataSource = NewsDataSource()
        
    lazy var viewModel : ArticleViewModel = {
        let viewModel = ArticleViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpIntials()
    }
    
    //MARK:- UI setu methods
    
    func setUpIntials() {
        
        //Setup UI
        self.title = kNewsTitleString
        self.activityIndicator.stopAnimating()

        self.articleTableView.rowHeight = UITableView.automaticDimension
        self.articleTableView.estimatedRowHeight = kEstimatedNewsRableRowHeight

        //Setup datasource
        self.articleTableView.dataSource = self.dataSource
        self.dataSource.data.addAndNotify(observer: self) { [weak self] in
            self?.articleTableView.reloadData()
        }
        
        // Fetch article if network available
        Utils.isConnectedToNetwork() ? fetchArticle() : showAlertWithMessgae(message: kNoNetworkErrorMessgae)
    }
    
    func fetchArticle()
    {
        self.activityIndicator.startAnimating()
        self.viewModel.fetchArticles({[weak self] result in
            
            self?.activityIndicator.stopAnimating()
            
            switch result{
                case .failure(let error):
                    self?.showAlertWithMessgae(message: error.localizedDescription)
                
                default:
                    NSLog("sucess")
            }
        })
    }
    
    //MARK:- Alert
    func showAlertWithMessgae(message:String) {
        
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        let action = UIAlertAction(title: kOkButtonTitle, style: .default, handler: nil)
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func callService ( urlString : String, httpMethod: String , data: Data , completion: @escaping (_ result: [String:AnyObject]) -> Void)
    {
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        // Set the method to POST
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set the POST/put body for the request
        request.httpBody = data
        request.setValue(String.init(format: "%i", (data.count)), forHTTPHeaderField: "Content-Length")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if data == nil
            {
                var errorResponse = [String : AnyObject]()
                errorResponse["Error"] = "Issue" as AnyObject?
                completion(errorResponse)
            }
            else
            {
                if  let utf8Text = String(data: data! , encoding: .utf8) {
                    completion(self.convertStringToDictionary(text: utf8Text)! as! [String : AnyObject])
                }
                else
                {
                    var errorResponse = [String : AnyObject]()
                    errorResponse["Error"] = "Issue" as AnyObject?
                    completion(errorResponse)
                }
            }
        })
        task.resume()
    }
    
    func convertStringToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary as! [String : AnyObject]? as NSDictionary?
            } catch let error as NSError {
                var errorResponse = [String : AnyObject]()
                errorResponse["Error"] = "Issue" as AnyObject?
                print(error)
                return errorResponse as NSDictionary?
            }
        }
        return nil
    }
   
}

//MARK:- Extension for TableViewDelegate handling
extension NewsViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: kNewDetailSegue, sender: self.dataSource.data.value[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kNewDetailSegue {
            let newsDetailVC = segue.destination as? NewsDetailUIViewController
            newsDetailVC?.detailNews = (sender as! ArticleCellViewModel).captionInfo
            newsDetailVC?.detailNewsImageUrl = (sender as! ArticleCellViewModel).imageUrl

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    
}

