//
//  ViewController.swift
//  CAShapeLayerpath-Test
//
//  Created by Simon Deutsch on 06.09.21.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var imageView: NSImageView!
    
    private let roundLayer = CAShapeLayer()
    private let progressBar = NSView()
    private let progressIndicator = NSProgressIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        setupProgressbar()
        let layer = CAShapeLayer()
        layer.path = NSBezierPath(rect: NSRect(x: 20, y: 20, width: 30, height: 30)).cgPath
        layer.fillColor = NSColor.green.cgColor
        
        view.layer?.addSublayer(layer)
        
        
    }

    
    var currentProgress: Double = 0.0 {
        didSet {
            update(currentProgress)
        }
    }
    
    private func update(_ progress: Double = 0.0) {
        self.roundLayer.path = self.progressPath(progress: progress/100)
    }
    
      
    private func progressPath(progress: Double = 0.0) -> CGPath {
        print("pro", progress)
        let aPath = CGMutablePath()
        
        let startAngle = CGFloat(-.pi/2.0)
        let endAngle = CGFloat((progress * 2.0 * .pi)-(.pi/2.0))
        
        print(startAngle, endAngle)

        aPath.addArc(
            center: CGPoint(x: self.progressBar.bounds.width/2.0, y: self.progressBar.bounds.height/2.0),
            radius: (self.progressBar.bounds.width)/2.0,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        return aPath
    }
    
    private func setupProgressbar() {
        progressBar.wantsLayer = true
        roundLayer.fillColor = NSColor.clear.cgColor
        roundLayer.strokeColor = NSColor.white.cgColor
        roundLayer.lineWidth = 2.0
        roundLayer.lineCap = CAShapeLayerLineCap.round
        
//        imageView.wantsLayer = true
//        imageView.layer?.addSublayer(roundLayer)
        
        progressBar.layer?.addSublayer(roundLayer)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(self.progressBar)

        let vConstraint02 = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[progressBar]-0-|",
            options: [],
            metrics: nil,
            views: ["progressBar": progressBar]
        )
        let hConstraints02 = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[progressBar]-0-|",
            options: [],
            metrics: nil,
            views: ["progressBar": progressBar]
        )


        self.view.addConstraints(vConstraint02)
        self.view.addConstraints(hConstraints02)
        
        update()
    }
    
    @IBAction func sliderChange(_ sender: Any) {
        guard let slider = sender as? NSSlider else { return }
        currentProgress = slider.doubleValue
    }
}

extension NSBezierPath {
    
    /// A `CGPath` object representing the current `NSBezierPath`.
    var cgPath: CGPath {
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)

        if elementCount > 0 {
            var didClosePath = true

            for index in 0..<elementCount {
                let pathType = element(at: index, associatedPoints: points)

                switch pathType {
                case .moveTo:
                    path.move(to: points[0])
                case .lineTo:
                    path.addLine(to: points[0])
                    didClosePath = false
                case .curveTo:
                    path.addCurve(to: points[2], control1: points[0], control2: points[1])
                    didClosePath = false
                case .closePath:
                    path.closeSubpath()
                    didClosePath = true
                @unknown default:
                    break
                }
            }

            if !didClosePath { path.closeSubpath() }
        }

        points.deallocate()
        return path
    }
}

