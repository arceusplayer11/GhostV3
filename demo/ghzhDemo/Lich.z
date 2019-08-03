// import "std.zh"
// import "string.zh"
// import "ghost.zh"

// Moves up and down the left side of the screen creating Stalfos and firing a variety of projectiles.
// Appears on screen 4 in the demo.

const int LICH_FIREBALL_SPRITE_1=11;
const int LICH_FIREBALL_SPRITE_2=89;
const int LICH_FIREBALL_SPRITE_3=17;
const int LICH_SKULL_BOMB_SPRITE=88;
const int LICH_STALFOS_SPAWNER_SPRITE=98;
const int LICH_SKULL_BOMB_SFX=62;
const int LICH_COMBO=25;
const int LICH_ATTACK_COMBO=26;

ffc script Lich
{
    void run()
    {
        npc ghost;
        
        ghost=Ghost_InitWait(this, 1, false);
        Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
        Ghost_SetHitOffsets(ghost, 0, 0, 0, 16); // The right column is just the hand
        Ghost_SpawnAnimationPuff(this, ghost);
        
        // Skull bomb splits into four smaller skulls on impact;
        // this is the prototype for those skulls
        eweapon prototype=CreateDummyEWeapon(EW_SCRIPT1, 150, 0, LICH_STALFOS_SPAWNER_SPRITE,
                                             LICH_SKULL_BOMB_SFX, EWF_SHADOW|EWF_NO_COLLISION);
        SetEWeaponMovement(prototype, EWM_THROW, 1.5, EWMF_DIE);
        SetEWeaponDeathEffect(prototype, EWD_SPAWN_NPC, NPC_STALFOS1);
        
        // Wait for three seconds initially, unless Link comes too close or attacks
        for(int i=0; i<180 && Distance(Ghost_X+16, Ghost_Y+16, Link->X, Link->Y)>64 && !Ghost_GotHit(); i++)
            LichWaitframe(this, ghost, 1);
        
        while(true)
        {
            // If there are fewer than two Stalfos, create some more
            if(Screen->NumNPCs()<3)
                CreateStalfos(this, ghost, prototype); 
            // Otherwise, pick an attack pattern at random
            else if(Rand(2)==0)
                DoAttack1(this, ghost);
            else
                DoAttack2(this, ghost);
            
            LichWaitframe(this, ghost, 90);
        }
    }
    
    
    // Fire icicles (fireballs, actually, but they look like icicles) that arc to the right,
    // then stop and aim at Link.
    void DoAttack1(ffc this, npc ghost)
    {
        eweapon wpn;
        
        Ghost_Data=LICH_ATTACK_COMBO;
        
        // Shoot a fireball every 1/4 second for 2 seconds
        for(int i=0; i<8; i++)
        {
            // Alternate between aiming upward and downward
            if(i%2==1)
                wpn=FireEWeapon(EW_FIREBALL, Ghost_X+24, Ghost_Y+16, -0.6, 250, 2,
                                LICH_FIREBALL_SPRITE_1, SFX_FIREBALL, EWF_ROTATE_360); 
            else
                wpn=FireEWeapon(EW_FIREBALL, Ghost_X+24, Ghost_Y+16, 0.6, 250, 2,
                                LICH_FIREBALL_SPRITE_1, SFX_FIREBALL, EWF_ROTATE_360);
            
            // Fireballs accelerate to the right, then stop after 3/4 second and aim at Link
            SetEWeaponMovement(wpn, EWM_VEER, DIR_RIGHT, 0.0185);
            SetEWeaponLifespan(wpn, EWL_TIMER, 40);
            SetEWeaponDeathEffect(wpn, EWD_AIM_AT_LINK, 30);
            
            LichWaitframe(this, ghost, 15);
        }
        
        Ghost_Data=LICH_COMBO;
    }
    
    
    // Fire two homing projectiles that explode on contact, and a series of
    // fireballs that move in a sine wave.
    void DoAttack2(ffc this, npc ghost)
    {
        eweapon wpn;
        
        Ghost_Data=LICH_ATTACK_COMBO;
        
        // Explosive homing projectiles
        wpn=FireEWeapon(EW_SCRIPT1, Ghost_X+24, Ghost_Y+8, -PI/8, 150, 2,
                        LICH_FIREBALL_SPRITE_2, SFX_FIREBALL, 0);
        SetEWeaponMovement(wpn, EWM_HOMING_REAIM, 5, 30);
        SetEWeaponLifespan(wpn, EWL_NEAR_LINK, 16);
        SetEWeaponDeathEffect(wpn, EWD_EXPLODE, 4);
        
        wpn=FireEWeapon(EW_SCRIPT1, Ghost_X+24 , Ghost_Y+24, PI/8, 150, 2,
                        LICH_FIREBALL_SPRITE_2, 0, 0);
        SetEWeaponMovement(wpn, EWM_HOMING_REAIM, 5, 30);
        SetEWeaponLifespan(wpn, EWL_NEAR_LINK, 16);
        SetEWeaponDeathEffect(wpn, EWD_EXPLODE, 4);
        
        // One waving fireball every 1/2 second for 3 seconds
        for(int i=0; i<6; i++)
        {
            wpn=FireEWeapon(EW_SCRIPT1, Ghost_X+24, Ghost_Y+16, 0, 300, 2,
                            LICH_FIREBALL_SPRITE_3, SFX_FIREBALL, 0);
            SetEWeaponMovement(wpn, EWM_SINE_WAVE, 24, 10+i*5);
            
            LichWaitframe(this, ghost, 30);
        }
        
        Ghost_Data=LICH_COMBO;
    }
    
    
    // Throw some projectiles that spawn Stalfos when they hit the ground.
    void CreateStalfos(ffc this, npc ghost, eweapon prototype)
    {
        eweapon wpn;
        
        // Wait until near the vertical center of the screen
        while(Abs(Ghost_Y-64)>8)
            LichWaitframe(this, ghost, 1);
        
        Ghost_Data=LICH_ATTACK_COMBO;
        
        // Projectiles are thrown at a random height and angle, and they split into
        // four parts when they land
        wpn=FireEWeapon(EW_SCRIPT1, Ghost_X+24, Ghost_Y+16, Rand(-45, 45)/100, 100, 2,
                        LICH_SKULL_BOMB_SPRITE, 0, EWF_SHADOW|EWF_NO_COLLISION);
        SetEWeaponMovement(wpn, EWM_THROW, Rand(25, 50)/10, EWMF_DIE);
        SetEWeaponDeathEffect(wpn, prototype, 4, EWD_RANDOM, 0);
        
        LichWaitframe(this, ghost, 10);
        
        Ghost_Data=LICH_COMBO;
    }


    void LichWaitframe(ffc this, npc ghost, int numFrames)
    {
        while(numFrames-->0)
        {
            // Update movement - float around the side of the screen
            if(Ghost_Y<64)
                Ghost_Vy=Min(Ghost_Vy+0.02, 2);
            else
                Ghost_Vy=Max(Ghost_Vy-0.02, -2);
            
            if(Ghost_X<56)
                Ghost_Vx=Min(Ghost_Vx+0.015, 1.5);
            else
                Ghost_Vx=Max(Ghost_Vx-0.015, -1.5);
            
            // Clear weapons on death
            if(!Ghost_Waitframe(this, ghost, true, false))
            {
                Screen->ClearSprites(SL_EWPNS);
                Quit();
            }
        }    
    }
}
