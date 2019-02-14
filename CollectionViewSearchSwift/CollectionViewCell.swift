

import UIKit
class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       // imageView.frame =  CGRect(x: 0, y: 0, width: 200, height: 200)
        //authorLbl.frame = CGRect(x: 0, y: , width: 300, height: 15)
        authorLbl.backgroundColor = UIColor.lightGray
        authorLbl.textColor = UIColor.black
    }
    
   
}
