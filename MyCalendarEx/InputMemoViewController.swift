//
//  InputMemoViewController.swift
//  MyCalendarEx
//
//  Created by Jay on 2018. 4. 1..
//  Copyright © 2018년 Jay. All rights reserved.
//

import UIKit

class InputMemoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var yearMonthDayLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    var gongsuOfTheDay: [Float] = [0.5, 1.0, 1.5, 2.0]
//    var numberOfEmptyBox: Int = 0
//    var preIndexPath = IndexPath()
    var daysInMonths = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]   //  0월은 존재X daysInMonths[0]은 값은 사용되지 않는다
    var itemArray = [Item]()
    var itemArrayIndex = Int()
    var strYearMonth = String()
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        yearMonthDayLabel.text = "\(strYearMonth)\(makeTwoDigitString(itemArrayIndex + 1))"
        memoTextView.text = itemArray.isEmpty ? "" : itemArray[itemArrayIndex].memo

    }
    
    @IBAction func saveMemoButtonAction(_ sender: Any) {
        
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
    

    
    // MARK: - Navigation
    // prepare()함수로 넘겨줄때는 Destination Viewcontroller의 현재 값을 사용할 수 없고
    // 초기화된 변수값만 가져오거나 쓸수 있다
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goMainCalendar" {
            
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
//        calendarCollectionView.reloadData()
    }
    
    func loadItems() {
        // 새 쌀은 새 포대에
//        monthlyGongsu = 0
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
    

    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gongsuOfTheDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GongsuCell", for: indexPath) as! GongsuCollectionViewCell
        cell.gongsuLabel.text = "\(gongsuOfTheDay[indexPath.row])"
        return cell
    }
}


















