
import Foundation


// 아래 변수들은 빌드가 완성되는 순간의 값일까 앱이 실행될때마다 갱신 되는 것 일까
let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day , from: date)
var weekday = calendar.component(.weekday , from: date)    // 한 주의시작을 월요일로 하려면 이 값에 -1 해준다
var month = calendar.component(.month , from: date)
var year = calendar.component(.year, from: date)

