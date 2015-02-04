//
//  TableApiViewController.swift
//  BaseProject
//
//  Created by wangyong on 15/2/2.
//  Copyright (c) 2015年 wang yong. All rights reserved.
//

import UIKit


class TableApiViewController: ModelApiViewController, UITableViewDelegate, UITableViewDataSource, TableViewDelegate {

    var _tableView: UITableView?
    var _loadFooterView: UIView?
    var _loadHeaderView: UIRefreshControl?
    var _headerLoading : Bool = true
    var _footerLoading : Bool = true
    
    var _activityIndicator: UIActivityIndicatorView?
    
    
    func activityIndicator()-> UIActivityIndicatorView{
        
        if(self._activityIndicator == nil){
            self._activityIndicator = UIActivityIndicatorView()
            self._activityIndicator!.center = self._tableView!.center
            self._activityIndicator!.startAnimating()
            self._tableView?.addSubview(self._activityIndicator!)
        }
        
        return self._activityIndicator!
    }
    
    var _enableHeader: Bool{
        set{
            if(newValue) {
                if (self._loadHeaderView == nil || self._loadHeaderView!.superview == nil) {
                    self._loadHeaderView = UIRefreshControl();
                    
                    self._loadHeaderView!.addTarget(self, action: Selector("refreshTableView:"), forControlEvents: UIControlEvents.ValueChanged)
                    self._loadHeaderView!.tintColor = UIColor.whiteColor();//[UIColor black75PercentColor];
                    self._tableView?.addSubview(self._loadHeaderView!)
                }else{
                    if (self._loadHeaderView != nil || self._loadHeaderView!.superview != nil){
                        self._loadHeaderView!.removeFromSuperview()
                        self._loadHeaderView = nil
                    }
                    
                }

            }
        }
        
        get{
            return self._enableHeader;
        }
    }
    
    func refreshTableView(refresh: UIRefreshControl){
        
        if activityIndicator().isAnimating() {
            return;
        }
        
        self._headerLoading = true;
        

        NSThread.detachNewThreadSelector(Selector("loadData:"), toTarget: self, withObject: true)
    }
    
    var _enableFooter: Bool{
        set{
            self._enableFooter = newValue;
            
            if (newValue) {
                self._tableView!.tableFooterView = self._loadFooterView!;
            }else {
                self._tableView!.tableFooterView = nil;
            }
        }
        
        get{
            return self._enableFooter;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self._tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        self._tableView!.dataSource = self
        self._tableView!.delegate = self
        
        
        self.view .addSubview(self._tableView!)
        
        self._enableHeader = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func cellClass()-> AnyClass?
    {
        assert(true, "please override cellClass")
        return nil
    }

    //tableView delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self._model == nil{
            return 0
        }else if self._model! is NSDictionary{
            return 1
        }
        
        return self._model!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var identifier: NSString = "cell_single"
        if indexPath.row/2 == 0{
            identifier = "cell_double"
        }
        
        var cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier(identifier);
        if (cell == nil) {
            var cls: AnyClass? = cellClass()
            var CellClass: UITableViewCell.Type = cls as UITableViewCell.Type
            cell = CellClass(style:UITableViewCellStyle.Default , reuseIdentifier: identifier)
        }
        
        initCellView(cell!, indexPath: indexPath)
        return cell! as UITableViewCell;
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var item: AnyObject? = nil
        if self._model != nil && self._model! is NSArray{
            item = self._model![indexPath.row]
        }
        else if self._model != nil && self._model! is NSDictionary{
            item = self._model;
        }
        
        var cls: AnyClass? = cellClass()

        return cls!.rowHeightForObject!(item!)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func initCellView(cell :AnyObject, indexPath: NSIndexPath){
        if cell .respondsToSelector(Selector("setObject:")){
            if(self._model!.count > indexPath.row)
            {
                var item: AnyObject? = nil
                if self._model != nil && self._model! is NSArray{
                    item = self._model![indexPath.row]
                }
                else if self._model != nil && self._model! is NSDictionary{
                    item = self._model;
                }
                
                if let temp_cell = cell as? TableViewDelegate {
                    temp_cell.setObject!(item!)
                }
            }
            
        }
    }
    
    //
    func activeRefresh() {
        self._tableView!.setContentOffset(CGPointMake(0, -(self._tableView!.contentInset.top + 60)), animated: false);
        self._loadHeaderView?.beginRefreshing()
        self.refreshTableView(self._loadHeaderView!)
        _headerLoading = true
    }
    
    
    //override request
    override func didFinishLoad(result: NSArray) {
        updateUserInterface(result)
        
        super.didFinishLoad(result)
        
        self._tableView!.reloadData();
    }
    
    func updateUserInterface(array: NSArray){
//        //存储缓存
//        if (self.loadmore == [NSNumber numberWithBool:NO]) {
//            if (array) {
//                [[MMDiskCacheCenter sharedInstance] setCache:array forKey:[self getCacheKey]];
//            }
//        }
        
        if self._activityIndicator != nil {
            self._activityIndicator!.stopAnimating();
        }
        
//        [_errorView removeFromSuperview];
        
        self._enableFooter = true
        
        if array.count == 0 {
            if self._model == nil {
                //list 为空
                
//                [self addSubErrorView];
                
                self._tableView!.reloadData()
                self._enableFooter = false
                
                if _headerLoading {
                    self._model = nil;
                    finishLoadHeaderTableViewDataSource()
//                    [self performSelector:@selector(finishLoadHeaderTableViewDataSource) withObject:nil afterDelay:0.01];
                }
                
                return;
            }
        }
        
        if array.count < self .getPageSize(){
//            self.hasMore = NO;
            //        [self.loadMoreFooterView setPWState:PWLoadMoreDone];
//            [self setEnableFooter:NO];
            self._enableFooter = false
            
        }else{
//            self.hasMore = YES;
//            [self.loadMoreFooterView setPWState:PWLoadMoreNormal];
            
        }
        
        if(_footerLoading)
        {
            finishLoadFooterTableViewDataSource()
        }
        
        if(_headerLoading)
        {
            self._model = nil;
            
            finishLoadHeaderTableViewDataSource()
        }

    }
    
    func finishLoadHeaderTableViewDataSource(){
    
        self._headerLoading = false
        self._loadHeaderView!.endRefreshing()
//        [self.refresh performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
        self._tableView!.setContentOffset(CGPointMake(0, -64), animated: true)
//        [[self getTableView] setContentOffset:CGPointMake(0, -64) animated:YES];
    }
    
    func finishLoadFooterTableViewDataSource(){
    
        self._footerLoading = false;
    
//        [self.loadMoreFooterView performSelectorOnMainThread:@selector(pwLoadMoreTableDataSourceDidFinishedLoading) withObject:nil waitUntilDone:NO];
    }


}
