// import "std.zh"
// import "string.zh"
// import "ghost.zh"

// An example of a script that enhances a regular enemy. This will create an electrical field
// around an enemy when Link gets close to it.
// Appears on screen 6 in the demo.

const int GRL_ELECTRICITY_SPRITE=97;
const int GRL_ELECTRICITY_SFX=61;

ffc script Grell
{
    void run(int enemyID)
    {
        eweapon electricity;
        npc grell=Ghost_InitAutoGhost(this, enemyID);
        Ghost_SpawnAnimationPuff(this, grell);
        
        while(true)
        {
            // If Link is close and grell isn't stunned, discharge electricity
            if(Distance(Link->X, Link->Y, Ghost_X, Ghost_Y)<32 && grell->Stun==0 && ClockIsActive()==0)
            {
                electricity=FireBigEWeapon(EW_SCRIPT1, Ghost_X-8, Ghost_Y-8, 0, 0, 8,
                                           GRL_ELECTRICITY_SPRITE, GRL_ELECTRICITY_SFX,
                                           EWF_UNBLOCKABLE|EWF_FLICKER, 2, 2);
                
                // Keep it positioned until it vanishes
                for(int i=0; i<90 && electricity->isValid(); i++)
                {
                    electricity->X=Ghost_X-8;
                    electricity->Y=Ghost_Y-8;
                    if(!GrlWaitframe(this, grell, false))
                    {
                        // Make sure it wasn't removed in the last frame
                        if(electricity->isValid())
                            electricity->DeadState=0;
                        Quit();
                    }
                }
                
                if(electricity->isValid())
                    electricity->DeadState=0;
                
                // Don't fire again for at least two seconds
                for(int i=0; i<120; i++)
                    GrlWaitframe(this, grell, true);
            }
            
            GrlWaitframe(this, grell, true);
        }
    }
    
    bool GrlWaitframe(ffc this, npc grell, bool quitOnDeath)
    {
        Ghost_Waitframe2(this, grell, true, quitOnDeath);
        
        if(Ghost_HP<=0)
        {
            if(quitOnDeath)
                Quit();
            else
                return false;
        }
            
        return true;
    }
}
