//
//  ViewController.swift
//  AlbumsCollectionViewAssignment
//
//  Created by Mac on 21/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var post : [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initilizeCollectionView()
        registerXibWithCollectionview()
        dataFetchFromApi()
       
    }
    
    func initilizeCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func registerXibWithCollectionview(){
        let uinib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(uinib, forCellWithReuseIdentifier: "CollectionViewCell")
        
    }
    
    func dataFetchFromApi(){
        
        let postUrl = URL(string: "https://jsonplaceholder.typicode.com/albums")
        var urlRequest = URLRequest(url: postUrl!)
        urlRequest.httpMethod = "Get"
        
        let urlSesson = URLSession(configuration: .default)
        
        var dataTask = urlSesson.dataTask(with: urlRequest) { postData, postResponse, postError in
            let postResponse = try! JSONSerialization.jsonObject(with: postData!)
            
            for eachResponse in postResponse as! [[String : Any]]
            {
                let postDictonary = eachResponse as! [String : Any]
                
                let userId = postDictonary["userId"] as! Int
                
                let id = postDictonary["userId"] as! Int
                
                let tittle = postDictonary["title"] as! String
                
                let postObject = Post(userId: userId, id: id, title: tittle)
                
                self.post.append(postObject)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        dataTask.resume()
    }

}

extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweetheCell : CGFloat = (flowLayout.minimumInteritemSpacing ?? 0.0) + (flowLayout.sectionInset.left ?? 0.0) + (flowLayout.sectionInset.right ?? 0.0)
        let size = (self.collectionView.frame.width - spaceBetweetheCell) / 2
        return CGSize(width: size, height: size)
    }
}

extension ViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as!
        CollectionViewCell
        collectionViewCell.userIdLabel.text = String(post[indexPath.item].userId)
        collectionViewCell.idLabel.text = String(post[indexPath.item].id)
        collectionViewCell.titleLabel.text = (post[indexPath.item].title)
        return collectionViewCell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        post.count
    }
}


extension ViewController : UICollectionViewDelegate{
    
}

