
import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var DaysInMonths = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]   //  0월은 존재X DaysInMonths[0]은 값은 사용되지 않는다
    var NumberOfEmptyBox = Int()    // The number of "empty boxex" at th start of the currnet month
    var NextNumberOfEmptyBox = Int()
    var PreviousNumberOfEmptyBox = Int()
    var Direction = 0   // = 0  현재달 , = 1 앞으로의 달 ,  = -1 지난달
    var PositionIndex = 0    // 매월 1일의 위치(요일) , 앞의 빈칸은 빈칸으로 채워진다
    var dayCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthLabel.text = "\(year)년  \(month)월"
        
        GetStartDateDayPosition()
    }

    
    func GetStartDateDayPosition() {
        switch Direction {
        case 0:                             // 현재 달일 경우
            
            if year % 4 == 0 {
                DaysInMonths[2] = 29
            } else {
                DaysInMonths[2] = 28
            }
            
            // 당월의 1일 앞 빈칸수 구하기, 달력보며 연구
            dayCounter = day % 7
            NumberOfEmptyBox = weekday - dayCounter
            if NumberOfEmptyBox < 0 {
                NumberOfEmptyBox += 7
            }
            
            // positionIndex (1일의 위치) ,  NumberOfEmptyBox (1일 앞의 빈 날짜 채우기)
            PositionIndex = NumberOfEmptyBox
            
        case 1...:                          // 다음버튼 눌렸을 시
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
            PositionIndex = NextNumberOfEmptyBox
            
        case -1:                            // 이전버튼 눌렸을 시
            PreviousNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex)%7)
            if PreviousNumberOfEmptyBox == 7 {
                PreviousNumberOfEmptyBox = 0
            }
            PositionIndex = PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }

    @IBAction func nextButtonAction(_ sender: Any) {
        Direction = 1
        
        switch month {
        case 12:
            month = 1
            year += 1
            
            if year % 4 == 0 {
                DaysInMonths[2] = 29
            } else {
                DaysInMonths[2] = 28
            }
            
            GetStartDateDayPosition()
            
            monthLabel.text = "\(year)년  \(month)월"
            calendarCollectionView.reloadData()
            
        default:
            
            GetStartDateDayPosition()
            
            month += 1  // 위에 GSDDP 함수 뒤에 있을 것
            monthLabel.text = "\(year)년  \(month)월"
            calendarCollectionView.reloadData()
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        Direction = -1
        
        switch month {
        case 1:
            month = 12
            year -= 1
            
            if year % 4 == 0 {
                DaysInMonths[2] = 29
            } else {
                DaysInMonths[2] = 28
            }
            
            GetStartDateDayPosition()
            
            monthLabel.text = "\(year)년  \(month)월"
            calendarCollectionView.reloadData()
        default:
            month -= 1
            
            GetStartDateDayPosition()
            
            monthLabel.text = "\(year)년  \(month)월"
            calendarCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction {
        case 0:
            return DaysInMonths[month] + NumberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + NextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! DateCollectionViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.dateLabel.textColor = UIColor.black
        
        if cell.isHidden {
            cell.isHidden = false
        }
        
        switch Direction {
        case 0:
            cell.dateLabel.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
        case 1...:
            cell.dateLabel.text = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
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
        
        // 현재날짜 표시
        if month == calendar.component(.month , from: date)
            && year == calendar.component(.year, from: date)
            && indexPath.row + 1 == day + NumberOfEmptyBox {
            cell.backgroundColor = UIColor.lightGray
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row) is selected")
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.white
    }
    
    @IBAction func memoButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "goInputMemo", sender: self)
    }
    @IBAction func gongsuButtonAction(_ sender: Any) {
        
    }
}

