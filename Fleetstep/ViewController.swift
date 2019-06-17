//
//  ViewController.swift
//  Fleetstep
//
//  Created by Wolfgang Walder on 17/06/19.
//  Copyright © 2019 Wolfgang Walder. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    var userAcceleration:CMAcceleration?
    
    let motion = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDeviceMotion()
    }
    
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            //Frequencia de atualização dos sensores definida em segundos - no caso, 60 vezes por segundo
            self.motion.deviceMotionUpdateInterval = 1.0 / 2.0
            self.motion.showsDeviceMovementDisplay = true
            //A partir da chamada desta função, o objeto motion passa a conter valores atualizados dos sensores; o parâmetro representa a referência para cálculo de orientação do dispositivo
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            //Um Timer é configurado para executar um bloco de código 60 vezes por segundo - a mesma frequência das atualizações dos dados de sensores. Neste bloco manipulamos as informações mais recentes para atualizar a interface.
            let timer = Timer(fire: Date(), interval: (1.0 / 2.0), repeats: true,
                              block: { (timer) in
                                if let data = self.motion.deviceMotion {
                                    let usrAcc = data.userAcceleration
                                    
                                    let xAcc = usrAcc.x
                                    let yAcc = usrAcc.y
                                    let zAcc = usrAcc.z
                                    
                                    let threshold:Double = 0.040
//                                    let dflt:Double = 0.000
                                    
//                                    self.textLabel.text = String(format: "%.3f", abs(xAcc) >= threshold ? xAcc : dflt) + " " + String(format: "%.3f", abs(yAcc) >= threshold ? yAcc : dflt) + " " + String(format: "%.3f", abs(zAcc) >= threshold ? zAcc : dflt)
                                    
                                    if xAcc >= threshold || yAcc >= threshold || zAcc >= threshold {
                                        self.textLabel.text = "NOT SNEAKY"
                                    } else {
                                        self.textLabel.text = "Sneaky like a Ninja"
                                    }
                                    
                                }
            })
            
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
    }
}
