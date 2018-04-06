
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK:  - 상수, 변수
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthlyGongsuLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
    var daysInMonths = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]   //  0월은 존재X daysInMonths[0]은 값은 사용되지 않는다
    var numberOfEmptyBox: Int = 0    // The number of "empty boxex" at th start of the currnet month
    var direction: Int = 0   // = 0  현재달 , = 1 앞으로의 달 ,  = -1 지난달
    var positionIndex: Int = 0    // 매월 1일의 위치(요일) , 앞의 빈칸은 빈칸으로 채워진다
    var dayCounter: Int = 0
    
    var strYearMonth = String()
    var preIndexPath = IndexPath()
    var monthlyGongsu = Float()
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
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
        let inputMemoViewController = (segue.destination as! InputMemoViewController)
//        inputMemoViewController.itemArray = itemArray
//        inputMemoViewController.numberOfEmptyBox = numberOfEmptyBox
//        inputMemoViewController.preIndexPath = preIndexPath
        inputMemoViewController.strYearMonth = strYearMonth
        inputMemoViewController.itemArrayIndex = preIndexPath.row - numberOfEmptyBox
        inputMemoViewController.dataFilePath = dataFilePath
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
                
                calculatedDate = self.preIndexPath.row - self.numberOfEmptyBox
                
                newItem.strDate = "\(self.strYearMonth)\(self.makeTwoDigitString(calculatedDate + 1))"
                print(newItem.strDate)
                newItem.strGongsu = textField.text!
                newItem.numGongsu = Float(textField.text!)!
                newItem.memo = self.itemArray[calculatedDate].memo
                
                
                if self.itemArray.isEmpty {
                    self.makeItemArray()
                }
                
                self.itemArray.remove(at: calculatedDate)
                self.itemArray.insert(newItem, at: calculatedDate)
              
                self.saveItems()
                
                self.calendarCollectionView.reloadData()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func makeTwoDigitString(_ number : Int) -> String {
        
        var convertedString = ""
        
        switch number {
        case 1...9:
            convertedString = "0\(number)"
        default:
            convertedString = "\(number)"
        }
        return convertedString
    }
    
    func makeItemArray() {
        for _ in 1...daysInMonths[month] {
            itemArray.append(Item())
        }
    }
    
    //MARK:  - PList 입출력
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: (dataFilePath?.appendingPathComponent("\(strYearMonth).plist"))!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        calendarCollectionView.reloadData()
    }
    
    func loadItems() {
        // 새 쌀은 새 포대에
        monthlyGongsu = 0
        itemArray.removeAll()
        if let data = try? Data(contentsOf: (dataFilePath?.appendingPathComponent("\(strYearMonth).plist"))!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}

