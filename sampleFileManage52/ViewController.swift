//  sampleFileManage52
import UIKit
import RealmSwift

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 表示内容の配列
    var collectionImages: [CollectionImage] = []
    
    // 画面が読み込まれたら
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // 画面が表示されたら
    override func viewDidAppear(_ animated: Bool) {
        loadImages()
    }
    
    // 画像をDBから取得する処理
    func loadImages() {
        // DB接続
        let realm = try! Realm()
        // データ全件取得
        collectionImages = realm.objects(CollectionImage.self).reversed()
        // コレクションビューの更新
        collectionView.reloadData()
    }
    
    // 何個表示するか
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionImages.count
    }

    // 何を表示するか
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 対象となる情報を一個取得
        let ci = collectionImages[indexPath.row]
        // 保存ディレクトリの取得
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        // 保存ディレクトリ + 画像のパス
        let url = documentPath.appendingPathComponent(ci.path)
        
        // セルに反映する処理
        // コレクションビューからセルの取得
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        // セルからイメージビューの取得
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        // イメージビューに画像を反映
        imageView.image = UIImage(contentsOfFile: url!.path)
        
        return cell
    }

}

