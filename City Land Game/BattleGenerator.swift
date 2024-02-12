//
//  BattleGenerator.swift
//  City Land Game
//
//  Created by Vadim Shicha on 2/10/24.
//

import Foundation;
import SpriteKit;
import GameplayKit;

enum BattleDifficulty: String {
    case VeryEasy = "Very Easy"
    case Easy = "Easy"
    case Medium = "Medium"
    case Hard = "Hard"
    case VeryHard = "Very Hard"
}

struct BattleGeneratorData {
    var difficulty: BattleDifficulty = BattleDifficulty.Easy;
    var forcesType: TankDataEnum = TankDataEnum.GreenTank;
    var id: Int = 1;
}

//enum BattleGeneratorType {
//    case EasyGreen1
//    case MediumGreen1
//    
//    case EasyTan1
//    case MediumTan1
//}


//class used to generate the forces of a battle
class BattleGenerator {
    
    static func generateBattle(roundAmount: Int, tanksPerRound: Int) -> BattleData {
        var battleData = BattleData(roundAmount: roundAmount);
        
        for _ in 0..<roundAmount {
            var roundData = BattleRoundData(roundLength: 10);
            
            for _ in 0..<tanksPerRound {
                var roundTank = BattleRoundTank();
                roundTank.tank = TankDataEnum.GreenTank;
                
                roundData.tanks.append(roundTank);
            }
            battleData.rounds.append(roundData);
        }
        
        return battleData;
    }
    
    static func getFixedBattle(generatorData: BattleGeneratorData) -> BattleData {
        if(generatorData.difficulty == BattleDifficulty.Easy) {
            if(generatorData.forcesType == TankDataEnum.GreenTank) {
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
            }
            else if(generatorData.forcesType == TankDataEnum.TanTank) {
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
            }
        }
        else if(generatorData.difficulty == BattleDifficulty.Medium) {
            if(generatorData.forcesType == TankDataEnum.GreenTank) {
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
            }
            else if(generatorData.forcesType == TankDataEnum.TanTank) {
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
        else if(generatorData.difficulty == BattleDifficulty.Hard) {
            
        }
        
        //if the battle generator data doesn't match any cases provide a simple valid battle
        return BattleData(
            rounds: [
                BattleRoundData(roundLength: 1, tanks: [
                    BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                    BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1),
                ])
            ],
            roundAmount: 1
        );
    }
}
