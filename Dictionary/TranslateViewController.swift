import Cocoa
import WebKit

class TranslateViewController: NSViewController {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            let url = URL(string: "https://translate.google.com.vn/#view=home&op=translate&sl=en&tl=vi")!
            webView.load(URLRequest(url: url))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
