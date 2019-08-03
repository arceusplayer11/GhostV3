// import "std.zh"
// import "string.zh"
// import "ghost.zh"

// Moves left and right for several seconds, regularly shooting splitting
// fireballs. After that, rolls into a ball and bounces around the screen.
// Appears on screen 5 in the demo quest.

const int IFL_WALK_COMBO=28;
const int IFL_ROLL_COMBO=31;
const int IFL_HAND1_COMBO=29;
const int IFL_HAND2_COMBO=30;

const int IFL_FIRE_SPRITE=21;
const int IFL_FIREBALL_SPRITE=17;

const int IFL_BATTLE_MIDI=11;
const int IFL_DUNGEON_MIDI=5;

ffc script Iflyte
{
    void run()
    {
        npc ghost;
        eweapon prototype;
        
        ghost=Ghost_InitWait(this, 1, false);
        Ghost_SetFlag(GHF_IGNORE_ALL_TERRAIN);
        Ghost_SpawnAnimationPuff(this, ghost);
        
        Ghost_AddCombo(IFL_HAND1_COMBO, -16, 16);
        Ghost_AddCombo(IFL_HAND2_COMBO, 48, 16);
        
        // Prototype for fireballs to split into
        prototype=CreateDummyEWeapon(EW_FIREBALL, 200, 2, IFL_FIREBALL_SPRITE, 13, 0);
        SetEWeaponLifespan(prototype, EWL_SLOW_TO_HALT, 2);
        SetEWeaponDeathEffect(prototype, EWD_VANISH, 0);
        
        Game->PlayMIDI(IFL_BATTLE_MIDI);
        
        while(true)
        {
            WalkAndShoot(this, ghost, prototype);
            RollAttack(this, ghost);
        }
    }
    
    
    // Walk back and forth at the top of the screen, regularly shooting fireballs.
    void WalkAndShoot(ffc this, npc ghost, eweapon prototype)
    {
        eweapon wpn;
        int time;
        
        // Start moving
        Ghost_Vy=0;
        if(Ghost_X>=104) // X=104 is centered
            Ghost_Vx=-1.5;
        else
            Ghost_Vx=1.5;
            
        time=Rand(180, 480); // 3-8 seconds
        
        for(int i=0; i<time; i++)
        {
            // Fire every 1.5 seconds
            if(i%90==0 && i>0)
            {
                for(int j=1; j<=3; j++) // 1, 2, 3 = down, left, right
                {
                    wpn=FireNonAngularEWeapon(EW_SCRIPT1, Ghost_X+16, Ghost_Y+16, j, 200, 2, IFL_FIRE_SPRITE, SFX_FIREBALL, EWF_UNBLOCKABLE|EWF_ROTATE);
                    SetEWeaponLifespan(wpn, EWL_SLOW_TO_HALT, 4);
                    SetEWeaponDeathEffect(wpn, prototype, 3, EWD_EVEN, 3*PI/2);
                }
            }
            
            // If at wall, change direction
            if(Ghost_X<=48)
                Ghost_Vx=1.5;
            else if(Ghost_X>=160)
                Ghost_Vx=-1.5;
            
            IflWaitframe(this, ghost);
        }
    }
    
    
    // Roll into an invincible ball and bounce around the room.
    void RollAttack(ffc this, npc ghost)
    {
        float angle;
        int bounces;
        int numBounces;
        int oldDefenses[18];
        
        // Become invincible while rolling
        Ghost_StoreDefenses(ghost, oldDefenses);
        Ghost_SetAllDefenses(ghost, NPCDT_BLOCK);
        
        // Transformation sequence
        Ghost_Vx=0;
        for(int i=0; i<32; i++)
        {
            int frame=i%4;
            if(frame==0)
                ChangeToNormal(this, ghost);
            else if(frame==2)
                ChangeToBall(this, ghost);
            IflWaitframe(this, ghost);
        }
        
        ghost->Damage+=2;
        
        // Start moving at a random angle, constrained to a certain range;
        // if it's too horizontal or too vertical, it's easy to avoid
        angle=Rand(30, 60)+90*Rand(2);// That's 30-60 or 120-150
        // If Link's at the top of the screen, roll upward first
        if(Link->Y<=Ghost_Y)
            angle+=180;
        Ghost_Vx=VectorX(5, angle);
        Ghost_Vy=VectorY(5, angle);
        
        // Bounce off the walls a certain number of times
        bounces=0;
        numBounces=Rand(15, 25);
        while(true)
        {
            // If near the edge of the screen, reverse direction
            if(Ghost_X<=32 || Ghost_X>=192)
            {
                bounces++;
                Ghost_Vx=-Ghost_Vx;
            }
            if(Ghost_Y<=32 || Ghost_Y>=112)
            {
                bounces++;
                Ghost_Vy=-Ghost_Vy;
            }
            
            // After bouncing long enough, break out of the loop when at
            // about the right height
            if(bounces>=numBounces && Abs(Ghost_Y-48)<3)
                break;
            
            IflWaitframe(this, ghost);
        }
        
        // Change back
        Ghost_SetDefenses(ghost, oldDefenses);
        ghost->Damage-=2;
        
        // Transformation sequence
        Ghost_Vx=0;
        Ghost_Vy=0;
        for(int i=0; i<32; i++)
        {
            int frame=i%4;
            if(frame==0)
                ChangeToBall(this, ghost);
            else if(frame==2)
                ChangeToNormal(this, ghost);
            IflWaitframe(this, ghost);
        }
    }
    
    
    void ChangeToBall(ffc this, npc ghost)
    {
        Ghost_Transform(this, ghost, IFL_ROLL_COMBO, -1, 2, -1);
        Ghost_ClearCombos();
    }
    
    
    void ChangeToNormal(ffc this, npc ghost)
    {
        Ghost_Transform(this, ghost, IFL_WALK_COMBO, -1, 3, -1);
        Ghost_AddCombo(IFL_HAND1_COMBO, -16, 16);
        Ghost_AddCombo(IFL_HAND2_COMBO, 48, 16);
    }
    
    
    void IflWaitframe(ffc this, npc ghost)
    {
        bool stillAlive=Ghost_Waitframe(this, ghost, false, false);
        
        // Explode if dead
        if(!stillAlive)
        {
            Ghost_DeathAnimation(this, ghost, 1);
            Game->PlayMIDI(IFL_DUNGEON_MIDI);
            Quit();
        }
    }
}
