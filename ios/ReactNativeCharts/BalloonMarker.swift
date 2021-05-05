//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 19/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//  https://github.com/danielgindi/Charts/blob/1788e53f22eb3de79eb4f08574d8ea4b54b5e417/ChartsDemo/Classes/Components/BalloonMarker.swift
//  Edit: Added textColor

import Foundation;

import Charts;

import SwiftyJSON;

open class BalloonMarker: MarkerView {
    open var color: UIColor?
    open var arrowSize = CGSize(width: 15, height: 10)
    open var font: UIFont?
    open var textColor: UIColor?
    open var minimumSize = CGSize()
    open var mainColor : UIColor!

    
    fileprivate var insets = UIEdgeInsets(top: 8.0,left: 8.0,bottom: 20.0,right: 8.0)
    fileprivate var topInsets = UIEdgeInsets(top: 20.0,left: 8.0,bottom: 8.0,right: 8.0)
    
    fileprivate var labelns: NSString?
    fileprivate var labelTitle: NSString?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _size: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key: Any]()
    fileprivate var _drawTitleAttributes = [NSAttributedString.Key: Any]()
    
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, customColor: UIColor? = nil) {
        self.mainColor = customColor ?? UIColor.black //UIColor(red: 0/255, green: 198/255, blue: 90/255, alpha: 1)
        super.init(frame: CGRect.zero);
        self.color = color
        if #available(iOS 8.2, *) {
            self.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        } else {
            self.font = font
        }
        self.textColor = textColor
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        
        _paragraphStyle?.alignment = .center
        
        if #available(iOS 8.2, *) {
            _drawTitleAttributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 10, weight: .semibold)
        } else {
            _drawTitleAttributes[NSAttributedString.Key.font] = font
        }
        
        _drawTitleAttributes[NSAttributedString.Key.paragraphStyle] = _paragraphStyle
        
        _drawTitleAttributes[NSAttributedString.Key.foregroundColor] = mainColor
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    
    func drawRect(context: CGContext, point: CGPoint) -> CGRect{
        
        let chart = super.chartView
        
        let width = _size.width
        
        var rect = CGRect(origin: point, size: _size)
        
        UIColor.white.setFill()
        mainColor.setStroke()
        let rc = CGRect(x: rect.origin.x - 5, y: rect.origin.y - 5, width: 10, height: 10);
        let oval = UIBezierPath(ovalIn: rc)
        oval.lineWidth = 3
        oval.fill()
        oval.stroke()
        
        if point.y - _size.height < 0 {
            
            rect.origin.y -= 2
            if point.x - _size.width / 2.0 < 0 {
                drawTopLeftRect(context: context, rect: rect)
            } else if (chart != nil && point.x + width - _size.width / 2.0 > (chart?.bounds.width)!) {
                rect.origin.x -= _size.width
                drawTopRightRect(context: context, rect: rect)
            } else {
                rect.origin.x -= _size.width / 2.0
                rect.origin.y += 8
                drawTopCenterRect(context: context, rect: rect)
            }
            
            rect.origin.y += self.topInsets.top
            rect.size.height -= self.topInsets.top + self.topInsets.bottom
            
            
        } else {
            
            rect.origin.y -= _size.height
            rect.origin.y += 2
            
            if point.x - _size.width / 2.0 < 0 {
                drawLeftRect(context: context, rect: rect)
            } else if (chart != nil && point.x + width - _size.width / 2.0 > (chart?.bounds.width)!) {
                rect.origin.x -= _size.width
                drawRightRect(context: context, rect: rect)
            } else {
                rect.origin.x -= _size.width / 2.0
                rect.origin.y -= 8
                drawCenterRect(context: context, rect: rect)
            }
            
            rect.origin.y += self.insets.top
            rect.size.height -= self.insets.top + self.insets.bottom
            
        }
        
        return rect
    }
    
    //done
    func drawCenterRect(context: CGContext, rect: CGRect) {
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        let r = CGRect.init(x: rect.origin.x + (rect.size.width/2) - 10, y: rect.origin.y + rect.size.height - 25, width: 20, height: 20)
        let center = CGPoint(x: r.midX, y: r.midY)
        let path = UIBezierPath(roundedRect: r, cornerRadius: 5)
        path.apply(CGAffineTransform(translationX: center.x, y: center.y).inverted())
        path.apply(CGAffineTransform(rotationAngle: 45 / 180.0 * .pi))
        path.apply(CGAffineTransform(translationX: center.x, y: center.y))
        context.addPath(path.cgPath)
        
        let clipPath: CGPath = UIBezierPath(roundedRect: CGRect.init(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height - arrowSize.height), cornerRadius: 13).cgPath
        context.addPath(clipPath)
        context.fillPath()
        
    }
    //    done
    func drawLeftRect(context: CGContext, rect: CGRect) {
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        let clipPath: CGPath = UIBezierPath(roundedRect: CGRect.init(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height - arrowSize.height), cornerRadius: 13).cgPath
        context.addPath(clipPath)
        let clipPath2: CGPath = UIBezierPath(roundedRect: CGRect.init(x: rect.origin.x, y: rect.origin.y + rect.size.height - arrowSize.height * 3, width: arrowSize.height * 2, height: arrowSize.height * 2), cornerRadius: 3).cgPath
        context.addPath(clipPath2)
        context.fillPath()
    }
    
    //    done
    func drawRightRect(context: CGContext, rect: CGRect) {
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        let clipPath: CGPath = UIBezierPath(roundedRect: CGRect.init(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height - arrowSize.height), cornerRadius: 13).cgPath
        context.addPath(clipPath)
        let clipPath2: CGPath = UIBezierPath(roundedRect: CGRect.init(x: rect.origin.x + (rect.size.width - arrowSize.height * 2), y: rect.origin.y + rect.size.height - arrowSize.height * 3, width: arrowSize.height * 2, height: arrowSize.height * 2), cornerRadius: 3).cgPath
        context.addPath(clipPath2)
        context.fillPath()
    }
    
    //    done
    func drawTopCenterRect(context: CGContext, rect: CGRect) {
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        let r = CGRect.init(x: rect.origin.x + (rect.size.width/2) - 10, y: rect.origin.y + 5, width: 20, height: 20)
        let center = CGPoint(x: r.midX, y: r.midY)
        let path = UIBezierPath(roundedRect: r, cornerRadius: 5)
        path.apply(CGAffineTransform(translationX: center.x, y: center.y).inverted())
        path.apply(CGAffineTransform(rotationAngle: 45 / 180.0 * .pi))
        path.apply(CGAffineTransform(translationX: center.x, y: center.y))
        context.addPath(path.cgPath)
        let clipPath: CGPath = UIBezierPath(roundedRect: CGRect.init(x: rect.origin.x, y: rect.origin.y + 10, width: rect.size.width, height: rect.size.height - arrowSize.height), cornerRadius: 13).cgPath
        context.addPath(clipPath)
        context.fillPath()
        
    }
    //    done
    func drawTopLeftRect(context: CGContext, rect: CGRect) {
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        let clipPath: CGPath = UIBezierPath(roundedRect: CGRect.init(x: rect.origin.x, y: rect.origin.y + arrowSize.height, width: rect.size.width, height: rect.size.height - arrowSize.height), cornerRadius: 13).cgPath
        context.addPath(clipPath)
        let clipPath2: CGPath = UIBezierPath(roundedRect: CGRect.init(x: rect.origin.x, y: rect.origin.y + arrowSize.height, width: arrowSize.height * 2, height: arrowSize.height * 2), cornerRadius: 3).cgPath
        context.addPath(clipPath2)
        context.fillPath()
        
    }
    
    func drawTriangle(size: CGFloat, x: CGFloat, y: CGFloat, up:Bool) -> UIBezierPath {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: x, y: y))
        trianglePath.addLine(to: CGPoint(x: x, y: y + size))
        trianglePath.addLine(to: CGPoint(x: x + size * 2, y: y + size))
        //        trianglePath.close()
        return trianglePath
    }
    
    //    done
    func drawTopRightRect(context: CGContext, rect: CGRect) {
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        let clipPath: CGPath = UIBezierPath(roundedRect: CGRect.init(x: rect.origin.x, y: rect.origin.y + arrowSize.height, width: rect.size.width, height: rect.size.height - arrowSize.height), cornerRadius: 13).cgPath
        context.addPath(clipPath)
        let clipPath2: CGPath = UIBezierPath(roundedRect: CGRect.init(x: rect.origin.x + (rect.size.width - arrowSize.height * 2), y: rect.origin.y + arrowSize.height, width: arrowSize.height * 2, height: arrowSize.height * 2), cornerRadius: 3).cgPath
        context.addPath(clipPath2)
        context.fillPath()
        
    }
    
    
    
    open override func draw(context: CGContext, point: CGPoint) {
        if (labelns == nil || labelns?.length == 0) {
            return
        }
        
        context.saveGState()
        
        let rect = drawRect(context: context, point: point)
        
        UIGraphicsPushContext(context)
        
        labelTitle?.draw(in: rect, withAttributes: _drawTitleAttributes)
        
        ("\n" + ((labelns != nil) ? (labelns! as String): "")).draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        
        var label : String;
        var title : String = "";
        
        if let candleEntry = entry as? CandleChartDataEntry {
            label = candleEntry.close.description
        } else {
            label = entry.y.description
        }
        
        if let object = entry.data as? JSON {
            if object["marker"].exists() {
                label = object["marker"].stringValue;
                title = object["title"].stringValue
                if highlight.stackIndex != -1 && object["marker"].array != nil {
                    label = object["marker"].arrayValue[highlight.stackIndex].stringValue
                    title = object["title"].arrayValue[highlight.stackIndex].stringValue
                }
            }
        }
        
        labelTitle = title as NSString
        
        labelns = label as NSString
        
        _drawAttributes.removeAll()
        
        _drawAttributes[NSAttributedString.Key.font] = self.font
        
        _drawAttributes[NSAttributedString.Key.paragraphStyle] = _paragraphStyle
        
        _drawAttributes[NSAttributedString.Key.foregroundColor] = self.textColor
        
        _labelSize = ("999999\n" + ((labelns != nil) ? (labelns! as String): "")).size(withAttributes: _drawAttributes)
        _size.width = _labelSize.width + self.insets.left + self.insets.right
        _size.height = _labelSize.height + self.insets.top + self.insets.bottom
        _size.width = max(minimumSize.width, _size.width)
        _size.height = max(minimumSize.height, _size.height)
        
    }
}

