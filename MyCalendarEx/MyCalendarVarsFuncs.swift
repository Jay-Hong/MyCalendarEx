
import Foundation


// 아래 변수들은 빌드가 완성되는 순간의 값일까 앱이 실행될때마다 갱신 되는 것 일까
let date = Date()
let calendar = Calendar.current
let day = calendar.component(.day , from: date)
var weekday = calendar.component(.weekday , from: date)    // 한 주의시작을 월요일로 하려면 이 값에 -1 해준다
var month = calendar.component(.month , from: date)
var year = calendar.component(.year, from: date)

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

// 나중에 년/월 선택이동을 가능하도록 하기위한 변수 들
//var xXXXXXXXXXX = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
//let secondsOfDay: Double = 60 * 60 * 24
//let secondsOfMonth28: Double = secondsOfDay * 28
//let secondsOfMonth29: Double = secondsOfDay * 29
//let secondsOfMonth30: Double = secondsOfDay * 30
//let secondsOfMonth31: Double = secondsOfDay * 31
//let secondsOfYear28: Double = (secondsOfMonth31 * 7) + (secondsOfMonth30 * 4) + secondsOfMonth28
//let secondsOfYear29: Double = (secondsOfMonth31 * 7) + (secondsOfMonth30 * 4) + secondsOfMonth29
//let sedondsOf4Year: Double = (secondsOfYear28 * 3) + secondsOfYear29
//
//let date2 = Date(timeIntervalSince1970: 0)  // 1970년 1월 1일 00시 00분 + 0초
//let date3 = Date(timeIntervalSinceReferenceDate: 0) // 2001년 1월 1일 00시 00분 + 0초
