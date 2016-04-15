//
//  AudioStreamViewController.swift
//  
//
//  Created by Rex Tsao on 3/14/16.
//
//

import UIKit

class AudioStreamViewController: UIViewController {
    
    private let adds = ["http://120.24.165.30/ShadoPan_A_Hero.mp3", "http://120.24.165.30/Vi_Music_Master_v16.mp3"]
    private let titles = ["ShadoPan_A_Hero.mp3", "Vi_Music_Master_v16.mp3"]
    private var queue: AFSoundQueue?
    private lazy var items = [AFSoundItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        let startButton = UIButton()
        startButton.setTitle("start", forState: .Normal)
        startButton.sizeToFit()
        startButton.addTarget(self, action: #selector(AudioStreamViewController.start), forControlEvents: .TouchUpInside)
        startButton.frame.origin = CGPointMake(0, 64)
        startButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        self.view.addSubview(startButton)
        
        let stopButton = UIButton()
        stopButton.setTitle("pause", forState: .Normal)
        stopButton.sizeToFit()
        stopButton.addTarget(self, action: #selector(AudioStreamViewController.pause), forControlEvents: .TouchUpInside)
        stopButton.frame.origin = CGPointMake(startButton.frame.origin.x + startButton.frame.width + 10, 64)
        stopButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        self.view.addSubview(stopButton)
        
        let tableView = UITableView(frame: CGRectMake(0, stopButton.frame.origin.y + stopButton.frame.height + 10, self.view.bounds.width, self.view.bounds.height - stopButton.frame.height - 10))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "music")
        self.view.addSubview(tableView)
        
        // AFSoundManager
        let item1 = AFSoundItem(streamingURL: NSURL(string: self.adds[0]))
        let item2 = AFSoundItem(streamingURL: NSURL(string: self.adds[1]))
        self.items.append(item1)
        self.items.append(item2)
        self.queue = AFSoundQueue(items: items)
        self.queue?.playCurrentItem()
        self.queue?.listenFeedbackUpdatesWithBlock({
            item in
            print("Item duration: \(item.duration) - time elapsed: \(item.timePlayed)")
            }, andFinishedBlock: {
                nextItem in
                print("Finished item, next one is \(nextItem.title)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.queue?.clearQueue()
    }
    
    func start() {
        print("[AudioStreamViewController:start] You touched the start button.")
        self.queue?.playCurrentItem()
    }
    
    func pause() {
        self.queue?.pause()
    }
}

extension AudioStreamViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("music")! as UITableViewCell
        cell.textLabel!.text = self.titles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.queue?.playItem(self.items[indexPath.row])
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
}
