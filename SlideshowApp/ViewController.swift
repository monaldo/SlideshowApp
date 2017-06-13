//
//  ViewController.swift
//  SlideshowApp
//
//  Created by Tomoo Motoki on 2017/06/10.
//  Copyright © 2017年 monaldo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // 画像制御のための準備
    let loadImages:[String] = ["photo1.jpg", "photo2.jpg", "photo3.jpg", "photo4.jpg"] // 配列に画像をセットして読み込む画像を決定
    var imageNumber: Int! = 0 // 配列から選択されるイメージ番号の初期値

    // タイマーの準備
    var timer: Timer!
    
    // スラードショーのスタートストップの制御
    var slideshowStartStop: Bool! = false // スライドショーのスタート・ストップの初期値
    
    // 詳細ページの戻るボタンで使う処理
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // イメージ描画
        imageView.image = UIImage(named: loadImages[imageNumber])
        
        // イメージにタップ機能を追加
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.imageViewTapped(_:))))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBOutlet weak var playstopButton: UIButton!
    @IBAction func startStopPicture(_ sender: UIButton) {

        // slideshowStartStopに対しての動作の処理
        if slideshowStartStop == false {
            starSlideshow() // スライドショー開始
        } else {
            stopSlideshow() // スライドショー停止
        }
    }
    
    // 戻るボタンの設定
    @IBOutlet weak var rewindButton: UIButton!
    @IBAction func rewindPicture(_ sender: UIButton) {
        if slideshowStartStop == false {
            imageCountDown()
        }
    }
    
    // 進むボタンの設定
    @IBOutlet weak var forwardButton: UIButton!
    @IBAction func forwardPicture(_ sender: UIButton) {
        if slideshowStartStop == false {
            imageCountUp()
        }
    }

    // タイマーでの処理
    func updateTimer(timer: Timer) {
        imageCountUp()
    }
    
    // 戻るを定義
    func imageCountDown() {
        imageNumber = (imageNumber + 3) % loadImages.count
        imageView.image = UIImage(named: loadImages[imageNumber])
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.imageViewTapped(_:))))
    }
    
    // 進むを定義
    func imageCountUp() {
        imageNumber = (imageNumber + 1) % loadImages.count
        imageView.image = UIImage(named: loadImages[imageNumber])
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.imageViewTapped(_:))))
    }
    
    // インターバルでスライドショー開始を定義
    func starSlideshow() {
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        // ボタンの制御
        playstopButton.setTitle("停止", for: .normal)
        rewindButton.isEnabled = false
        forwardButton.isEnabled = false
        rewindButton.setTitleColor(UIColor.darkGray, for: .normal)
        forwardButton.setTitleColor(UIColor.darkGray, for: .normal)
        slideshowStartStop = true
    }
    
    // スライドショー停止を定義
    func stopSlideshow() {
        self.timer.invalidate()
        
        // ボタンの制御
        playstopButton.setTitle("再生", for: .normal)
        rewindButton.isEnabled = true
        forwardButton.isEnabled = true
        rewindButton.setTitleColor(UIColor.white, for: .normal)
        forwardButton.setTitleColor(UIColor.white, for: .normal)
        slideshowStartStop = false
    }
    
    // 画像タップのアクションを定義
    func imageViewTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "detailPage", sender: self.loadImages[imageNumber])
        if slideshowStartStop != false {
            stopSlideshow() // スライドショー停止
        }
    }
    
    // 詳細にパラメータを渡す準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailImageViewController:DetailImageViewController = segue.destination as! DetailImageViewController
        detailImageViewController.imageName = loadImages[imageNumber]
    }
}

