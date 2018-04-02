//
//  InputMemoViewController.swift
//  MyCalendarEx
//
//  Created by Jay on 2018. 4. 1..
//  Copyright © 2018년 Jay. All rights reserved.
//

import UIKit

class InputMemoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var memoTextView: UITextView!
    
    var gongsuOfTheDay: [Float] = [0.5, 1.0, 1.5, 2.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gongsuOfTheDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GongsuCell", for: indexPath) as! GongsuCollectionViewCell
        cell.gongsuLabel.text = "\(gongsuOfTheDay[indexPath.row])"
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */

}
