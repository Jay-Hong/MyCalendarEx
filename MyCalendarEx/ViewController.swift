
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK:  - 상수, 변수
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthlyGongsuLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(dataFilePath!)
        
        getStartDateDayPosition()

    }

    
    //MARK:  - 달력 날짜 위치 설정 함수
    func getStartDateDayPosition() {
        switch direction {
        case 0:         // 현재 달일 경우
            monthLabel.text = "\(year)년  \(month)월"
            strYearMonth = "\(year)\(makeTwoDigitString(month))"
            loadItems()
            
            daysInMonths[2] = year % 4 == 0 ? 29 : 28
            
            // 당월의 1일 앞 빈칸수 구하기, 달력보며 연구
            dayCounter = day % 7
            numberOfEmptyBox = weekday - dayCounter
            if numberOfEmptyBox < 0 {
                numberOfEmptyBox += 7
            }
            
            // positionIndex (1일의 위치) ,  NumberOfEmptyBox (1일 앞의 빈 날짜 채우기)
            positionIndex = numberOfEmptyBox
            
        case 1:         // 다음버튼 눌렸을 시
            numberOfEmptyBox = (positionIndex + daysInMonths[month])%7
            positionIndex = numberOfEmptyBox
            
        case -1:        // 이전버튼 눌렸을 시
            numberOfEmptyBox = (7 - (daysInMonths[month] - positionIndex)%7)
            if numberOfEmptyBox == 7 {
                numberOfEmptyBox = 0
            }
            positionIndex = numberOfEmptyBox
        default:
            fatalError()
        }
    }

    //MARK:  - 달력 전 후 버튼
    @IBAction func nextButtonAction(_ sender: Any) {
        direction = 1
        
        switch month {
        case 12:
            month = 1
            year += 1
            
            daysInMonths[2] = year % 4 == 0 ? 29 : 28
            
            getStartDateDayPosition()

        default:
            getStartDateDayPosition()
            month += 1  // 위에 GSDDP 함수 뒤에 있을 것
        }
        monthLabel.text = "\(year)년  \(month)월"
        strYearMonth = "\(year)\(makeTwoDigitString(month))"
        loadItems()
        calendarCollectionView.reloadData()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        direction = -1
        
        switch month {
        case 1:
            month = 12
            year -= 1
            
            daysInMonths[2] = year % 4 == 0 ? 29 : 28
            
            getStartDateDayPosition()
            
        default:
            month -= 1
            getStartDateDayPosition()
        }
        
        monthLabel.text = "\(year)년  \(month)월"
        strYearMonth = "\(year)\(makeTwoDigitString(month))"
        loadItems()
        calendarCollectionView.reloadData()
    }
    
    //MARK:  - UICollectionViewDataSource 함수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        monthlyGongsu = 0
        return daysInMonths[month] + numberOfEmptyBox
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! DateCollectionViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.dateLabel.textColor = UIColor.black
        
        if cell.isHidden {
            cell.isHidden = false
        }
        
        cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        
        if Int(cell.dateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        
        // 주말 날짜색 설정
        switch indexPath.row {
        case 0,7,14,21,28,35,42:
            if Int(cell.dateLabel.text!)! > 0 {
                cell.dateLabel.textColor = UIColor.red
            }
        case 6,13,20,27,34,41:
            if Int(cell.dateLabel.text!)! > 0 {
                cell.dateLabel.textColor = UIColor.blue
            }
        default:
            break
        }
        
        // preIndexPagh 설정 (해당월이면 오늘 / 다른달이면 1일)
        if (indexPath.row - numberOfEmptyBox == 0) && (month != calendar.component(.month , from: date) || year != calendar.component(.year, from: date)) {
            preIndexPath = indexPath
            cell.backgroundColor = UIColor.white
        }
        
        // 현재날짜 표시
        if month == calendar.component(.month , from: date)
            && indexPath.row + 1 == day + numberOfEmptyBox
            && year == calendar.component(.year, from: date) {
            cell.backgroundColor = UIColor.lightGray
//            if preIndexPath.isEmpty {
                preIndexPath = indexPath
                cell.backgroundColor = UIColor.white
//            }
        }
        
        // 화면에 데이터 뿌려주기
        if indexPath.row >= numberOfEmptyBox {
            cell.strGongsuLabel.text = itemArray.isEmpty ? "" : itemArray[indexPath.row - numberOfEmptyBox].strGongsu
            cell.memoLabel.text = itemArray.isEmpty ? "" : itemArray[indexPath.row - numberOfEmptyBox].memo
            monthlyGongsu += itemArray.isEmpty ? 0 : itemArray[indexPath.row - numberOfEmptyBox].numGongsu
            if (indexPath.row + 1) == (daysInMonths[month] + numberOfEmptyBox) {
                monthlyGongsuLabel.text = String(monthlyGongsu)
            }
        }

        return cell
    }
    
    //MARK:  - 날짜 선택시
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row) is selected")
        
        collectionView.cellForItem(at: preIndexPath)?.backgroundColor = UIColor.clear
        
        // 오늘은 그대로 색 유지
        if month == calendar.component(.month , from: date)
            && preIndexPath.row + 1 == day + numberOfEmptyBox
            && year == calendar.component(.year, from: date) {
            collectionView.cellForItem(at: preIndexPath)?.backgroundColor = UIColor.lightGray
        }
        
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.white
        preIndexPath = indexPath
    }
    
    //MARK:  - 메모입력
    @IBAction func memoButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "goInputMemo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let inputMemoViewController = (segue.destination as! InputMemoViewController)
    }
    
    //MARK:  - 공수입력
    @IBAction func gongsuButtonAction(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "공수를 입력하세요", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "공수입력"
            alertTextField.keyboardType = UIKeyboardType.decimalPad
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "저장", style: .default) { (action) in
            if textField.text != "" {
                
                let newItem = Item()
                var calculatedDate = Int()
                
                calculatedDate = preIndexPath.row - numberOfEmptyBox
                
                newItem.strDate = "\(strYearMonth)\(makeTwoDigitString(calculatedDate + 1))"
                print(newItem.strDate)
                newItem.strGongsu = textField.text!
                newItem.numGongsu = Float(textField.text!)!
                newItem.memo = itemArray[calculatedDate].memo

                if itemArray.isEmpty {
                    makeItemArray()
                }
                
                itemArray.remove(at: calculatedDate)
                itemArray.insert(newItem, at: calculatedDate)
              
                saveItems()
                
                self.calendarCollectionView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}

