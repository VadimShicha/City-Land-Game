//
//  BattleGenerator.swift
//  City Land Game
//
//  Created by Vadim Shicha on 2/10/24.
//

import Foundation;
import SpriteKit;
import GameplayKit;

enum BattleGeneratorType {
    case EasyGreen1
    case MediumGreen1
    
    case EasyTan1
    case MediumTan1
}

//class used to generate the forces of a battle
class BattleGenerator {
    
    static func generateBattle(roundAmount: Int, tanksPerRound: Int) -> BattleData {
        var battleData = BattleData(roundAmount: roundAmount);
        
        for i in 0..<roundAmount {
            var roundData = BattleRoundData(roundLength: 10);
            
            for j in 0..<tanksPerRound {
                var roundTank = BattleRoundTank();
                roundTank.tank = TankDataEnum.GreenTank;
                
                roundData.tanks.append(roundTank);
            }
            battleData.rounds.append(roundData);
        }
        
        return battleData;
    }
    
    static func getFixedBattle(generatorType: BattleGeneratorType) -> BattleData {
        switch(generatorType) {
            case BattleGeneratorType.EasyGreen1:
                return BattleData(
                    rounds: [
                        BattleRoundData(roundLength: 3, tanks: [
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 2),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3)
                        ]),
                        BattleRoundData(roundLength: 5, tanks: [
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 5)
                        ]),
                        BattleRoundData(roundLength: 7, tanks: [
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 2),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 2.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 5.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 6),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 6.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 7)
                        ])
                    ],
                    roundAmount: 3
                );
            case BattleGeneratorType.MediumGreen1:
                return BattleData(
                    rounds: [
                        BattleRoundData(roundLength: 3, tanks: [
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 2),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3)
                        ]),
                        BattleRoundData(roundLength: 5, tanks: [
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 5)
                        ]),
                        BattleRoundData(roundLength: 7, tanks: [
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 2),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 2.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 5.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 6),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 6.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 7)
                        ])
                    ],
                    roundAmount: 3
                );
            case BattleGeneratorType.EasyTan1:
                return BattleData(
                    rounds: [
                        BattleRoundData(roundLength: 3, tanks: [
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 2),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 3)
                        ]),
                        BattleRoundData(roundLength: 5, tanks: [
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 4),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 4.5),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 5)
                        ]),
                        BattleRoundData(roundLength: 7, tanks: [
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 0.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 1.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 2),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 2.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 3.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 4.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 5),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 5.5),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 6),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 6.5),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 7)
                        ])
                    ],
                    roundAmount: 3
                );
            case BattleGeneratorType.MediumTan1:
                return BattleData(
                    rounds: [
                        BattleRoundData(roundLength: 3, tanks: [
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0.5),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 1.5),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 2),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 3)
                        ]),
                        BattleRoundData(roundLength: 5, tanks: [
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 3),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 4),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 4.5),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 5)
                        ]),
                        BattleRoundData(roundLength: 7, tanks: [
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 0.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 1.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 2),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 2.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 3.5),
                            BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 4.5),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 5),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 5.5),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 6),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 6.5),
                            BattleRoundTank(tank: TankDataEnum.TanTank, time: 7)
                        ])
                    ],
                    roundAmount: 3
                );
        }
    }
}
