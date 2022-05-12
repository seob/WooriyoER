//
//  DayViewTableViewCell.swift
//  PinPle
//
//  Created by seob on 2020/06/15.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class DayViewTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitleDay: UILabel!
    @IBOutlet weak var lblTaskTime: UILabel!
    @IBOutlet weak var TextFieldStartTime: AwesomeTextField!
    @IBOutlet weak var TextFieldEndTime: AwesomeTextField!
    
    @IBOutlet weak var TextFieldbkStartTime: AwesomeTextField!
    @IBOutlet weak var TextFieldbkEndTime: AwesomeTextField!
    
    
    var startdt = ""
    var enddt = ""
    var bkstarttm = ""
    var bkendtm = ""
    var inputData = ""
    var tmflag = 0
    var dateFormatter = DateFormatter()
    var dateFormatter2 = DateFormatter()
    var dayweek = 0
    var strDayTitle = ""
    var wdysid = 0
    
    var celuvList : MultiConstractDate = MultiConstractDate()
    var onClick : (_ vod : MultiConstractDate) -> Void = {
        vod in
    }
    
    var partnetList : [MultiConstractDate] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func clickAction(_ sender: Any) {
        
        var starttm:Int = 0
        var endtm:Int = 0
        var bkstm:Int = 0
        var bketm:Int = 0
        var nDistance:uint = 0
        starttm = startdt != "" ? calTime(startdt.timeTrim()) : 0
        endtm = enddt != "" ? calTime(enddt.timeTrim()) : 0
        bkstm = bkstarttm != "" ? calTime(bkstarttm.timeTrim()) : 0
        bketm = bkendtm != "" ? calTime(bkendtm.timeTrim()) : 0
        if (starttm > 0 && endtm > 0){
            
            if endtm > starttm {
                if endtm > starttm {
                    if bketm == 0 {
                        nDistance = uint((endtm - starttm) - (bketm - bkstm))
                    }else if bkstm == 0 {
                        nDistance = uint((endtm - starttm) - (bkstm - bketm))
                    }else{
                        if bketm > bkstm {
                            if bkstm > bketm {
                                nDistance = uint((endtm - starttm) - (bketm - bkstm))
                            }else{
                                nDistance = uint((endtm - starttm) - (bketm - bkstm))
                            }
                        }else{
                            if bkstm > bketm {
                                nDistance = uint((endtm - starttm) - (bketm - bkstm))
                            }else{
                                nDistance = uint((endtm - starttm) - (bkstm - bketm))
                            }

                        }
                    }

                }else{
                    if bketm > bkstm {
                        nDistance = uint((starttm - endtm) - (bketm - bkstm))
                    }else{
                        nDistance = uint((starttm - endtm) - (bkstm - bketm))
                    }
                }

            }else{
                if endtm > starttm {
                    nDistance = uint((starttm - endtm) - (bketm - bkstm))
                }else{
                    nDistance = uint((starttm - endtm) - (bkstm - bketm))
                }
            }
        }else{
            nDistance = 0
        }
        
        print("\n---------- [ workmin : \(Int(nDistance))] ----------\n")
        celuvList.starttm = startdt
        celuvList.endtm = enddt
        celuvList.brkstarttm = bkstarttm
        celuvList.brkendtm = bkendtm
        
        celuvList.workmin = Int(nDistance)
        
        SelMultiArrTemp.append(celuvList)
        onClick(celuvList)
        
    }
    
    
    //시간차 계산
    fileprivate func calTime(_ StrTime: String) -> Int{
        var starttm :Int = 0
        if StrTime != "" {
            let startArr = StrTime.components(separatedBy: ":")
            let selHour: Int  = Int(startArr[0]) ?? 0
            let selMin:Int  = Int(startArr[1]) ?? 0
            starttm = (selHour*60) + selMin
        }else{
            starttm = 0
        }
        
        return starttm
    }
    
    
    //분을 4h 40m 으로 환산
    func getMinTohm(_ nDistance: Int) -> String {
        var strbDhm: String = ""
        if (nDistance == 0) {
            strbDhm = "0시간"
        } else {
            var nHour = 0
            var nMin = 0
            nHour = (nDistance) / 60
            nMin = (nDistance) % 60
            
            if (nMin != 0){
                
                strbDhm = "\(nHour)시간 \(nMin)분"
            } else {
                strbDhm = "\(nHour)시간"
            }
        }
        return strbDhm
    }
    
    
    
    @IBAction func datePicker(_ sender: UITextField) {
        let goDatePickerView = UIDatePicker()
        if #available(iOS 13.4, *) {
            goDatePickerView.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        var loc: Locale?
        
        startdt = TextFieldStartTime.text ?? ""
        enddt = TextFieldEndTime.text ?? ""
        bkstarttm = TextFieldbkStartTime.text ?? ""
        bkendtm = TextFieldbkEndTime.text ?? ""
        
        if sender == TextFieldStartTime {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = startdt
            tmflag = 0
        }else if sender == TextFieldEndTime {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = enddt
            tmflag = 1
        }else if sender == TextFieldbkStartTime {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = bkstarttm
            tmflag = 2
        }else if sender == TextFieldbkEndTime {
            goDatePickerView.datePickerMode = UIDatePicker.Mode.time
            goDatePickerView.minuteInterval = 10
            dateFormatter.dateFormat = "HH:mm"
            loc = Locale(identifier: "en_GB")
            inputData = bkendtm
            tmflag = 3
        }
        
        goDatePickerView.locale = loc
        sender.inputView = goDatePickerView
        
        print("inputData = ", inputData)
        if inputData != "" {
            let date = dateFormatter.date(from: inputData)
            goDatePickerView.date = date!
        }
        
        goDatePickerView.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        switch tmflag {
        case 0:
            self.TextFieldStartTime.becomeFirstResponder()
        case 1:
            self.TextFieldEndTime.becomeFirstResponder()
        case 2:
            self.TextFieldbkStartTime.becomeFirstResponder()
        case 3:
            self.TextFieldbkEndTime.becomeFirstResponder()
        default:
            break;
        }
    }
    
    @objc func datePickerValueChanged(_ sender:UIDatePicker) {
        switch tmflag {
        case 0:
            self.startdt = dateFormatter.string(from: sender.date)
            self.TextFieldStartTime.text = self.startdt
            celuvList.starttm = self.TextFieldStartTime.text ?? "90:00"
        case 1:
            self.enddt = dateFormatter.string(from: sender.date)
            self.TextFieldEndTime.text = self.enddt
            celuvList.endtm = self.TextFieldEndTime.text ?? "18:00"
        case 2:
            self.bkstarttm = dateFormatter.string(from: sender.date)
            self.TextFieldbkStartTime.text = self.bkstarttm
            celuvList.brkstarttm = self.TextFieldbkStartTime.text ?? "12:00"
        case 3:
            self.bkendtm = dateFormatter.string(from: sender.date)
            self.TextFieldbkEndTime.text = self.bkendtm
            celuvList.brkendtm = self.TextFieldbkEndTime.text ?? "13:00"
        default:
            break;
        }
        
    }
    
    @available(iOS 9.0, *)
    open func updateContentViews() {
        
    }
    
}


