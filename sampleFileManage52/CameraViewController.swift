import UIKit
import RealmSwift

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func runCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    // 撮影後に実行されるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 撮影した画像をイメージビューに反映する
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
            imageView.contentMode = .scaleAspectFit
        }
        // カメラ画面を閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedSaveBtn(_ sender: Any) {
        if let image = imageView.image {
            let fileName = getTimestamp() + ".png"
            // DBに保存
            saveFileName(fileName)
            // 画像を保存
            savePhoto(image, fileName: fileName)
            // 画面遷移
            performSegue(withIdentifier: "toTop", sender: nil)
        }
    }
    
    // 画像を保存する処理
    func savePhoto(_ image: UIImage, fileName: String) {
        // PNGデータに変換
        let pngImage = image.pngData()
        do {
            // 保存先ディレクトリの取得
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            // ディレクトリ名 + ファイル名
            let path = url!.path + "/" + fileName
            // ファイルの書き込み
            try pngImage?.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print("画像の保存失敗")
            return
        }
    }
    
    // DBに画像のパスを保存する
    func saveFileName(_ fileName: String) {
        let ci = CollectionImage()
        ci.path = fileName
        let realm = try! Realm()
        try! realm.write {
            realm.add(ci)
        }
    }
    
    // タイムスタンプを取得
    func getTimestamp() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyyMMddHHmmss"
//        format.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return format.string(from: date)
    }
    
}
