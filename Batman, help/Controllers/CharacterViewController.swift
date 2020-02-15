//
//  CharacterViewController.swift
//  BatmanHelp
//
//  Created by Enzo Maruffa Moreira on 13/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit
import Charts

class CharacterViewController: UIViewController {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterFullNameLabel: UILabel!
    @IBOutlet weak var baseNameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    
    @IBOutlet weak var chartsView: RadarChartView!
    
    var character: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterImageView.image = UIImage(named: character.assetName)
        characterNameLabel.attributedText = character.attributedString(withFont: UIFont(name: "BatmanForeverAlternate", size: 25)!)
        
        characterFullNameLabel.text = character.fullName
        baseNameLabel.text = character.baseLocation
        weightLabel.text = character.weight.description + "kg"
        heightLabel.text = character.height.description + "cm"
        occupationLabel.text = character.occupation ?? " - "
        
        
        if character.type == .villain {
            characterFullNameLabel.textColor = .neonRed
            baseNameLabel.textColor = .neonRed
            weightLabel.textColor = .neonRed
            heightLabel.textColor = .neonRed
            occupationLabel.textColor = .neonRed
        }
        
        // CHARTING
        // Dataset creation
        let powerstats = character.powerstats
        
        let intelligenceData = RadarChartDataEntry(value: Double(powerstats.intelligence))
        let strenghData = RadarChartDataEntry(value: Double(powerstats.strengh))
        let combatData = RadarChartDataEntry(value: Double(powerstats.combat))
        let durabilityData = RadarChartDataEntry(value: Double(powerstats.durability))
        let speedData = RadarChartDataEntry(value: Double(powerstats.speed))
        let powerData = RadarChartDataEntry(value: Double(powerstats.power))
        
        let dataset = RadarChartDataSet(entries: [intelligenceData, strenghData, combatData, durabilityData, speedData, powerData])
        
        // Dataset styling
        
        var gradientColors: CFArray
        if character.type == .hero {
            dataset.valueColors = [UIColor.neon]
            gradientColors = [UIColor.neon.cgColor, UIColor.black.cgColor] as CFArray // Colors of the gradient
        } else {
            dataset.valueColors = [UIColor.neonRed]
            gradientColors = [UIColor.neonRed.cgColor, UIColor.black.cgColor] as CFArray // Colors of the gradient
        }
        
        let colorLocations: [CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        dataset.fill = Fill.fillWithRadialGradient(gradient!, startOffsetPercent: .zero, startRadiusPercent: 0, endOffsetPercent: .zero, endRadiusPercent: 0.5)
        dataset.drawFilledEnabled = true // Draw the Gradient
        
        dataset.drawValuesEnabled = false
        
        // Data creation
        let data = RadarChartData(dataSets: [dataset])
        
        // Chart styling
        chartsView.data = data
        
        let labels = ["INT", "STG", "CBT", "DRB", "SPD", "PWR", "???"]
        chartsView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return labels[Int(index)]
        })
        
        chartsView.legend.enabled = false
        chartsView.backgroundColor = .background
        
        let yAxis = chartsView.yAxis
        yAxis.labelFont = UIFont(name: "BatmanForeverAlternate", size: 9)!
        yAxis.labelCount = 4
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 92
        yAxis.drawLabelsEnabled = false
        yAxis.gridColor = .lightBackground
        
        
        let xAxis = chartsView.xAxis
        xAxis.labelFont = UIFont(name: "BatmanForeverAlternate", size: 13)!
        xAxis.labelCount = 6
        xAxis.labelTextColor = .white
        xAxis.drawLabelsEnabled = true
        xAxis.gridColor = .lightBackground
        
        chartsView.contentScaleFactor = 0.8
        
        chartsView.notifyDataSetChanged()
        chartsView.sizeToFit()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
