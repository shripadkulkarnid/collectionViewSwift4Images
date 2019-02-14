



import UIKit

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ,UISearchBarDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionSearchBar: UISearchBar!
    var cellIdentifier = "Cell"
    var numberOfItemsPerRow : Int = 2
    var dataSource:[String]?
    var dataSourceForSearchResult:[String]?
    var searchBarActive:Bool = false
    var searchBarBoundsY:CGFloat?
    var refreshControl:UIRefreshControl?
    var model:[ModelElement] = []
    var cellWidth:CGFloat{
        return collectionView.frame.size.width/2
    }
    let url = URL(string:"https://picsum.photos/list")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        collectionSearchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        urlDataRead()
        collectionSearchBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        urlDataRead()
    }
    
    func urlDataRead(){
        //  To read values from URLs:
    
        
        URLSession.shared.dataTask(with: url!) { (data, response
            , error) in
            
            guard let data = data else{return}
            do{
                let decoder = JSONDecoder()
                let getJsonData = try decoder.decode(Model.self, from: data)
                self.model = getJsonData
               
               
            }catch let err {
                print("Err", err)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            }.resume()
        
        
    }
    
    // MARK: Search
    func filterContentForSearchText(searchText:String){
        self.dataSourceForSearchResult = self.dataSource?.filter({ (text:String) -> Bool in
            return text.contains(searchText)
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            self.searchBarActive    = true
            self.filterContentForSearchText(searchText: searchText)
            self.collectionView?.reloadData()
        }else{
            self.searchBarActive = false
            self.collectionView?.reloadData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self .cancelSearching()
        self.collectionView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.collectionSearchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = false
        self.collectionSearchBar.setShowsCancelButton(false, animated: false)
    }
    func cancelSearching(){
        self.searchBarActive = false
        self.collectionSearchBar.resignFirstResponder()
        self.collectionSearchBar.text = ""
    }
    
    
    // MARK: <UICollectionViewDataSource>
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        let data = model[indexPath.row]
        cell.tag = indexPath.row
        let urlImage = "https://picsum.photos/300/300?image=\(data.id!)"
        let url = URL(string: urlImage)
        DispatchQueue.global().async {
            let dataImage = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if cell.tag == indexPath.row{
                cell.imageView.image = UIImage(data: dataImage!)
                }
                else{
                    cell.imageView.image = UIImage(named: "thumbnil")
                }
            }
        }
        cell.authorLbl.text = data.author
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return model.count
    }
    
    func buttonTapped(indexPath: IndexPath) {
        print("success")
    }
  
    // MARK: <UICollectionViewDelegateFlowLayout>
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        return CGSize(width: size, height: size)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
   
}


