
import UIKit

class InputMemoViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var yearMonthDayLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    
    var itemArrayIndex = preIndexPath.row - numberOfEmptyBox

    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 15
        popupView.layer.masksToBounds = true
        
        loadItems()
        yearMonthDayLabel.text = "\(year)년 \(month)월 \(makeTwoDigitString(itemArrayIndex + 1))일"
        memoTextView.text = itemArray.isEmpty ? "" : itemArray[itemArrayIndex].memo

    }
    
    @IBAction func saveMemoButtonAction(_ sender: Any) {
        
        direction = 3
        let newItem = Item()
        
        if itemArray.isEmpty {
            makeItemArray()
            newItem.memo = memoTextView.text
            newItem.strDate = "\(strYearMonth)\(makeTwoDigitString(itemArrayIndex + 1))"
        } else {
            newItem.memo = memoTextView.text
            newItem.strDate = itemArray[itemArrayIndex].strDate
            newItem.strGongsu = itemArray[itemArrayIndex].strGongsu
            newItem.numGongsu = itemArray[itemArrayIndex].numGongsu
        }

        itemArray.remove(at: itemArrayIndex)
        itemArray.insert(newItem, at: itemArrayIndex)
        saveItems()
    }

    @IBAction func backgroundButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Navigation
    // prepare()함수로 넘겨줄때는 Destination MainViewcontroller의 현재 값을 사용할 수 없고
    // 초기화된 변수값만 가져오거나 쓸수 있다
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "tomainViewController" {
//
//        }
//    }

}


















