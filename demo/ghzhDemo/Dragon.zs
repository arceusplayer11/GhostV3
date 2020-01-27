// import "std.zh"
// import "string.zh"
// import "ghost.zh"

// A simple boss that moves up and down the side of the screen,
// periodically firing waving fireballs in three directions.
// Appears on screen 2 in the demo.

const int DRG_ENEMY_ID=183;

ffc script Dragon
{
    void run()
    {
        npc ghost;        
        int timer;
        int weaponSprite;
        int weaponDamage;
        eweapon wpn;
        
        // Initialize
        ghost=Ghost_InitCreate(this, DRG_ENEMY_ID);
        Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
        
        Ghost_SpawnAnimationPuff(this, ghost);
        Ghost_SetHitOffsets(ghost, 16, 0, 0, 0);
        
        // Set up weapon and firing timer
        if(ghost->Weapon!=0)
        {
            weaponSprite=GetDefaultEWeaponSprite(ghost->Weapon);
            weaponDamage=ghost->WeaponDamage;
            timer=Rand(60, 180);
        }
        
        Ghost_Vx=0.2;
        Ghost_Vy=0.3;
        
        while(true)
        {
            // If a weapon is set, fire every 1-3 seconds
            if(ghost->Weapon!=0)
            {
                timer--;
                if(timer<=0)
                {
                    timer=Rand(60, 180);
                    
                    // Fire three fireballs aimed at Link, each moving in a sine wave
                    for(int j=0; j<3; j++)
                    {
                        wpn=FireAimedEWeapon(EW_FIREBALL, Ghost_X+32, Ghost_Y+32, Sign(j-1)*PI/8, 200, weaponDamage, weaponSprite, SFX_FIREBALL, 0);
                        SetEWeaponMovement(wpn, EWM_SINE_WAVE, 8, 15);
                    }
                }
            }
            
            DrgWaitframe(this, ghost);
        }
    }
    
    
    void DrgWaitframe(ffc this,  npc ghost)
    {
        // Move with Vx and Vy; reverse if at edge of movement area
        if(Ghost_X<=32)
            Ghost_Vx=0.2;
        else if(Ghost_X>=63)
            Ghost_Vx=-0.2;
        
        if(Ghost_Y<=32)
            Ghost_Vy=0.3;
        else if(Ghost_Y>=95)
            Ghost_Vy=-0.3;
        
        Ghost_Waitframe(this, ghost, true, true);
    }
}
