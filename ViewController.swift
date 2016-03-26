//
//  ViewController.swift
//  collectionview_xmixdrix
//
//  Created by admin on 3/4/16.
//  Copyright © 2016 il.ac.afeka. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
{

    var pictures:[String] = ["1","2","3","4","5","6","7","8"]
    var visibleCells:[String]=[]
    var numInactiveCards=0
    var numSections = 0
    var numCols = 0
     var timer = NSTimer()
    var counter=0
     let delay_t = 0.5
   
    
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var ScoreInputLabel: UILabel!
    @IBOutlet weak var playbutton: UIButton!
    @IBOutlet weak var UIcv: UICollectionView!
    @IBOutlet weak var WinningLabel: UILabel!
    
    
    override func viewDidLoad()
   
    {
        super.viewDidLoad()
       
        
        pictures+=pictures
        numCols=Int(sqrt(Float(pictures.count)))
        numSections=numCols
        
        playbutton.setTitle("Start", forState: .Normal)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func timerAction()
    {
        counter+=1
        ScoreInputLabel.text = "\(counter)"
    }
    
    @IBAction func playAndReset(sender: AnyObject)
    {
        ScoreInputLabel.text="0"
        WinningLabel.hidden=true
        gameInit()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.timerAction), userInfo: nil, repeats: true)
        playbutton.hidden=true
    }
    
    
    func delay(delay:Double, closure:()->())
    {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    override func didReceiveMemoryWarning()
    {
    
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numCols
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numSections
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell=collectionView.dequeueReusableCellWithReuseIdentifier("cellidentifier", forIndexPath: indexPath) as! CollectionViewCell
              return cell
    }
    
    func gameInit()
    {
        counter=0
        var tmpPictures = pictures
        for  i in 0 ..< UIcv.numberOfSections()
        {
            for  j in 0 ..< UIcv.numberOfItemsInSection(i)
            {
                
                let cell=UIcv.cellForItemAtIndexPath(NSIndexPath(forItem: j,inSection: i)) as! CollectionViewCell
                let rnd = getRandom(tmpPictures.count)
                
                cell.cellLabel.text="?"
                
                cell.initCard(tmpPictures[rnd])
                tmpPictures.removeAtIndex(rnd)
                numInactiveCards=0
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell=collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        
        if(!cell.isFlipped && cell.isActive  )
        {
            cell.flipCard()
            
            self.visibleCells.append(cell.cardPicture)
            print("visiblecards: \(self.visibleCells) \n count:\( self.visibleCells.count)")
            
            if(self.visibleCells.count>=2)
            {
                CheckIfSuitablePair(collectionView )
                 self.visibleCells.removeAll()
            }
            
        }
            
    }
    
    //checking if pair is good, if bad pair it unflips if good, checks for winning
    func CheckIfSuitablePair(cv: UICollectionView)
    {
        
        let cmpResult=compareCards(visibleCells[0], card2: self.visibleCells[1])
        
        for  i in 0 ..< cv.numberOfSections()
        {
            for  j in 0 ..< cv.numberOfItemsInSection(i)
            {
                
                let cell=cv.cellForItemAtIndexPath(NSIndexPath(forItem: j,inSection: i)) as! CollectionViewCell
                
                
                if(cell.isActive && cell.isFlipped)
                {
                    if(!cmpResult) //cards are different
                    {delay(delay_t){cell.flipCard()}}
                    
                    else //cards are same
                    {
                        cell.isActive=false
                        self.numInactiveCards+=1
                        
                        if(checkWin())
                        {updateWinningLabels()}
                    }
                }
            }
        }
    }
    

    
    func checkWin()->Bool
    {
        if(numInactiveCards==pictures.count)
        {return true}
        return false
    }
    
    func updateWinningLabels()
    {
        timer.invalidate()
        playbutton.setTitle("Play again", forState: .Normal)
        playbutton.hidden=false
        WinningLabel.hidden=false
    }
    
    func compareCards(card1:String , card2:String) -> Bool
    {
        if(card1==card2)
        {return true}
        else {return false}
    }
    
    func getRandom(range: Int)->Int
    {
        srand(1)
        let random = arc4random_uniform(UInt32(range))
        return Int(random)
    }
}


