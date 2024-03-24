CHEATS = {}
CHEATS["EXPBOOST"] = true
CHEATS["CATCH"] = true

module GameData
  class GrowthRate
    def add_exp(exp1, exp2)
      ret =  Settings::LEVEL_CAPS[$Trainer.badge_count]
      if $game_switches[SWITCH_GAME_DIFFICULTY_HARD]
        ret =  Settings::LEVEL_CAPS[$Trainer.badge_count] * Settings::HARD_MODE_LEVEL_MODIFIER
      end
      if  CHEATS["EXPBOOST"]
        return (minimum_exp_for_level(ret.to_f.ceil.to_i)).clamp(1, maximum_exp) + 1
      else
        return (exp1 + exp2).clamp(0, maximum_exp)
      end
    end
  end
end
class Game_Map
  def debugMapEvent
    for i in @map.events.keys
      event = @map.events[1]
    end
  end
end
ModMenuCommands.register("cheats",{
  "parent"      => "main",
  "name"        => _INTL("Cheats"),
  "description" => _INTL("Cheats"),
})
ModMenuCommands.register("EXP",{
    "parent"      => "cheats",
    "name"        => _INTL("EXP Boost"),
    "description" => _INTL("Get a massive EXP boost"),
    "effect"      => proc{
      CHEATS["EXPBOOST"] = !CHEATS["EXPBOOST"]
      if CHEATS["EXPBOOST"]
        pbMessage("Enabled")
      else
        pbMessage("Disabled")
      end
    }
    })
    ModMenuCommands.register("Catch",{
    "parent"      => "cheats",
    "name"        => _INTL("Always Catch"),
    "description" => _INTL("Always Catch"),
    "effect"      => proc{

    CHEATS["CATCH"] = !CHEATS["CATCH"]
      if CHEATS["CATCH"]
        pbMessage("Enabled")
      else
        pbMessage("Disabled")
      end
    }})
ModMenuCommands.register("debugger",{
  "parent"      => "cheats",
  "name"        => _INTL("Debug mode"),
  "description" => _INTL("Enables Debug mode"),
  "effect"      => proc{
    $DEBUG = !$DEBUG
  }
  })

  ModMenuCommands.register("starterpack",{
      "parent"      => "cheats",
      "name"        => _INTL("Startepack"),
      "description" => _INTL("Adds Rarecandy, Balls, Repel, Evo Items and other Usefull Items to your bag"),
      "effect"      => proc{
        pbPlayDecisionSE
        itemHash = [[:RARECANDY, 999], [:QUICKBALL, 999], [:POKEBALL, 999], [:GREATBALL, 999],
        [:ULTRABALL, 999], [:MAXREPEL, 999], [:TELEPORTER, 1], [:LANTERN, 1], [:WATERSTONE, 10],
        [:LEAFSTONE, 10], [:SUNSTONE, 10], [:MOONSTONE, 10], [:THUNDERSTONE, 10], [:FIRESTONE, 10],
        [:DAWNSTONE, 10], [:SHINYSTONE, 10], [:MAGNETSTONE, 10], [:ITEMFINDER, 1], [:ESCAPEROPE, 100],
        [:SOOTHEBELL, 10], [:PPMAX, 10], [:DOWSINGMACHINE, 10], [:INFINITEREVERSERS, 1], [:INFINITESPLICERS, 100]]
        for item, count in itemHash
          $PokemonBag.pbStoreItem(item, count - pbQuantity(item))
        end
      }
})
ModMenuCommands.register("difficulty",{
  "parent"      => "cheats",
  "name"        => _INTL("Difficulty Hard"),
  "description" => _INTL("Sets difficulty to hard"),
  "effect"      => proc{
  $game_switches[SWITCH_GAME_DIFFICULTY_HARD] = true
  }
})
  module BallHandlers

    def self.isUnconditional?(ball,battle,battler)
      ret = IsUnconditional.trigger(ball,battle,battler)
      return (ret!=nil) ? ret : CHEATS["CATCH"]
    end
  end
