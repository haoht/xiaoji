//
//  XTMorningNoteController.swift
//  xiaoji
//
//  Created by xiaotei's MacBookPro on 16/3/6.
//  Copyright © 2016年 xiaotei's MacBookPro. All rights reserved.
//

import UIKit

let dateTimeStr = "yyyy-MM-dd"




class XTMorningNoteController: XTBaseViewController,NoteFlowViewDelegate,AddTitleItemControllerDelegate {

    var MYDB:FMDatabase? = nil
    
    var dateString:String?
    
    var dateFormatter:NSDateFormatter{
        get{
            let formatter = NSDateFormatter()
            formatter.dateFormat = dateTimeStr
            return formatter
        }
    }
    
    var noteContentView:XTNoteFlowView? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weakSelf = self
        // Do any additional setup after loading the view.
        self.commonInit()
    }
    
    func commonInit(){
        MYDB = XTDB.getDb()
//        self.navigationController?.navigationBar.hidden = true
        self.title = "晨记"
        dateString = dateFormatter.stringFromDate(NSDate())
        let rightButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "rightButtonAction:")

        self.navigationItem.rightBarButtonItem = rightButtonItem

        
        noteContentView = XTNoteFlowView(frame: self.view.bounds)

        noteContentView?.dateString = dateString!
        self.view.addSubview(noteContentView!)

        noteContentView?.superDelegate = self
        
        let currentDate = NSDate()
        noteContentView?.initWithClosure(noteFlowViewAction)
        noteContentView?.dateString = dateFormatter.stringFromDate(currentDate)
//        print(dateFormatter.stringFromDate(currentDate))
        
        XTDB.initTitieAndItemWithDate(dateFormatter.stringFromDate(currentDate))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    weak var weakSelf:XTMorningNoteController?
    func noteFlowViewAction(view:XTNoteFlowView,titleModel:TitleModel){
        let itemEditVC = XTNoteItemEditController()
        itemEditVC.titleModel = titleModel
        weakSelf?.navigationController?.pushViewController(itemEditVC, animated: true)
    }
    
    
    func rightButtonAction(barItem:UIBarButtonItem){
        noteContentView?.isEdit = !(noteContentView?.isEdit)!
    }

    func noteFlowViewAddTitleAction(view: XTNoteFlowView) {
        let addTitleVC = XTAddTitleItemController()
        addTitleVC.dateString = view.dateString
        addTitleVC.delegate = self
        self.navigationController?.pushViewController(addTitleVC, animated: true)
    }
    
    func addTitleItemController(controller: XTAddTitleItemController, reloaddate dateStr: String) {
        noteContentView?.dateString = dateString
        noteContentView?.collectionView.reloadData()
    }
}
