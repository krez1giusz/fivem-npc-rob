Ultrax = {
    Robbing = {
        minPd = 0,
        RobTime = 2, -- czas w sekundach
        Rewards = {
            LootChance = math.random(1,3),
            Cash = {
                amount = math.random(4000,5000)
            },
            Items = {
                {
                  name = 'bread',
                  count = math.random(1,2)
                },
                {
                    name = 'water',
                    count = math.random(1,2)
                },
            }
        }
    },
    Hostage = {
        takeTime = 2, -- w sekundach
        Anims = {
            Aggressor = {dict = 'anim@gangops@hostage@', anim = 'perp_idle'},
            Victim = {dict = 'anim@gangops@hostage@', anim = 'victim_idle', attachX = -0.24, attachY = 0.11}
        }
    }

}