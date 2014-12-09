
class Plot {}

typedef Plot PlotType();

class Plots {
  Plot FindMyMissingItem() { throw new Exception(); }

  Plot KillTheMonsterInMyHouse() { throw new Exception(); }
  
  Plot DefendTheVillageFromTheMonster() { throw new Exception(); }
  
  List<PlotType> get plotList => 
    [FindMyMissingItem, KillTheMonsterInMyHouse, DefendTheVillageFromTheMonster];
  
}

class Monster {}

typedef Monster MonsterType();

class Encounters {
  Monster Rats() => throw new Exception();
  
  Monster Bats() => throw new Exception();
  
  Monster Nightling() => throw new Exception();

  Monster FeralHedgehogs() => throw new Exception();

  Monster MadDog() => throw new Exception();

  Monster GiantFrogs() => throw new Exception();

  Monster WyrmLarvae() => throw new Exception();

  Monster Possum() => throw new Exception();
  
  List<MonsterType> get smallMonsterEncounters =>
      [Rats, Bats, Nightling, FeralHedgehogs, MadDog, GiantFrogs, WyrmLarvae, Possum];
}

