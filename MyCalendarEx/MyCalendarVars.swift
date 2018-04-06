
import Foundation


// 아래 변수들은 빌드가 완성되는 순간의 값일까 앱이 실행될때마다 갱신 되는 것 일까
let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day , from: date)
var weekday = calendar.component(.weekday , from: date)    // 한 주의시작을 월요일로 하려면 이 값에 -1 해준다
var month = calendar.component(.month , from: date)
var year = calendar.component(.year, from: date)

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
