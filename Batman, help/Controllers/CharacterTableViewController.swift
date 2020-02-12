//
//  CharacterViewController.swift
//  Batman, help
//
//  Created by Enzo Maruffa Moreira on 12/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit
import Charts

class CharacterTableViewController: UITableViewController {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var chartsView: RadarChartView!
    
    var character: Character!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dataset creation
        let powerstats = character.powerstats
        
        let intelligenceData = RadarChartDataEntry(value: Double(powerstats.intelligence))
        let strenghData = RadarChartDataEntry(value: Double(powerstats.strengh))
        let combatData = RadarChartDataEntry(value: Double(powerstats.combat))
        let durabilityData = RadarChartDataEntry(value: Double(powerstats.durability))
        let speedData = RadarChartDataEntry(value: Double(powerstats.speed))
        let powerData = RadarChartDataEntry(value: Double(powerstats.power))
        
        let dataset = RadarChartDataSet(entries: [intelligenceData, strenghData, combatData, durabilityData, speedData, powerData])
        
        dataset.valueColors = [UIColor.neon]
        
        // Dataset styling
        let gradientColors = [UIColor.cyan.cgColor, UIColor.red.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        dataset.fill = Fill.fillWithRadialGradient(gradient!, startOffsetPercent: .zero, startRadiusPercent: 0, endOffsetPercent: .zero, endRadiusPercent: 0.5)
        dataset.drawFilledEnabled = true // Draw the Gradient
        
        dataset.drawValuesEnabled = false
        
        // Data creation
        let data = RadarChartData(dataSets: [dataset])
        
        // Chart styling
        
        chartsView.legend.enabled = false
        chartsView.backgroundColor = .background
        
        let yAxis = chartsView.yAxis
        yAxis.labelFont = UIFont(name: "BatmanForeverAlternate", size: 9)!
        yAxis.labelCount = 3
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 100
        yAxis.drawLabelsEnabled = false
        yAxis.gridColor = .lightBackground
        
        
        let xAxis = chartsView.xAxis
        xAxis.labelFont = UIFont(name: "BatmanForeverAlternate", size: 13)!
        xAxis.labelCount = 6
        xAxis.labelTextColor = .white
        xAxis.drawLabelsEnabled = true
        xAxis.gridColor = .lightBackground
        
        chartsView.data = data
        
        let labels = ["Intelligence", "Strengh", "Combat", "Durability", "Speed", "Power", "???"]
        chartsView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return labels[Int(index)]
        })
        
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
