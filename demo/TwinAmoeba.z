// import "std.zh"
// import "string.zh"
// import "ghost.zh"

// AutoGhost enemy. Spawns two invincible slime enemies and jumps back and forth between them.
// Appears on screen 3 in the demo.

const float TWA_JUMP_SPEED=2;

// npc->Attributes[] indices
const int TWA_ATTR_SLIME_ID=0;
const int TWA_ATTR_JUMP_SOUND=1;
const int TWA_ATTR_LAND_SOUND=2;
const int TWA_ATTR_JUMPY=3;

ffc script TwinAmoeba
{
    void run(int enemyID)
    {
        npc ghost;
        npc slime[2];
        int currentSlime;
        bool jumpy;
        lweapon wpn;
        int i;
        
        // Initialize
        ghost=Ghost_InitAutoGhost(this, enemyID);
        Ghost_SetFlag(GHF_NO_FALL);
        Ghost_SetFlag(GHF_CLOCK);
        Ghost_SetFlag(GHF_SET_OVERLAY);
        
        jumpy=ghost->Attributes[TWA_ATTR_JUMPY]!=0;
        currentSlime=0;
        
        Ghost_SpawnAnimationPuff(this, ghost);
        
        // Create the first slime at the core's position; the second is randomly placed
        slime[0]=Screen->CreateNPC(ghost->Attributes[TWA_ATTR_SLIME_ID]);
        slime[0]->X=Ghost_X;
        slime[0]->Y=Ghost_Y;
        slime[1]=SpawnNPC(ghost->Attributes[TWA_ATTR_SLIME_ID]);
        
        Ghost_SetAllDefenses(slime[0], NPCDT_IGNORE);
        Ghost_SetAllDefenses(slime[1], NPCDT_IGNORE);
        
        while(true)
        {
            // If the core just got hit, jump to the other slime
            if(Ghost_GotHit())
            {
                SlimeJump(this, ghost, slime[currentSlime], slime[currentSlime^1], true);
                currentSlime^=1; // Switch index between 0 and 1
            }
            // If Link is too close and the other slime is farther, jump over
            else if(Distance(Ghost_X, Ghost_Y, Link->X, Link->Y)<32)
            {
                if(SlimeJump(this, ghost, slime[currentSlime], slime[currentSlime^1], false))
                    currentSlime^=1;
            }
            else if(jumpy)
            {
                // Jumpy ones jump whenever a weapon is too close
                for(i=Screen->NumLWeapons(); i>0; i--)
                {
                    wpn=Screen->LoadLWeapon(i);
                    
                    // This could be a lot of checks, so just look at X and Y difference
                    if(Abs(wpn->X-Ghost_X)<32 && Abs(wpn->Y-Ghost_Y)<32)
                    {
                        SlimeJump(this, ghost, slime[currentSlime], slime[currentSlime^1], true);
                        currentSlime^=1;
                        break;
                    }
                }
            }
            
            Ghost_X=slime[currentSlime]->X;
            Ghost_Y=slime[currentSlime]->Y;
            
            TwAWaitframe(this, ghost, slime[0], slime[1]);
        }
    }
    
    
    // Jump from one slime to the other. If not forced, it won't jump if the other slime is
    // closer to Link. Returns true if it jumps, false if not.
    bool SlimeJump(ffc this, npc ghost, npc startSlime, npc destSlime, bool force)
    {
        // If not forced, see if the destination slime is closer to Link than the starting slime;
        // if so, don't do anything
        if(!force)
        {
            if(Distance(startSlime->X, startSlime->Y, Link->X, Link->Y)>=Distance(destSlime->X, destSlime->Y, Link->X, Link->Y))
                return false;
        }
    
        int startX;
        int startY;
        int targetX;
        int targetY;
        float angle;
        float totalDist;
        float currentDist;
        
        // Ignore clocks while jumping so the core doesn't get stuck in midair
        Ghost_UnsetFlag(GHF_CLOCK);
        Game->PlaySound(ghost->Attributes[TWA_ATTR_JUMP_SOUND]);
        
        // Jump
        do
        {
            // Get the current position of the two slimes
            startX=startSlime->X;
            startY=startSlime->Y;
            targetX=destSlime->X;
            targetY=destSlime->Y;
            
            // Move toward one from the other
            angle=Angle(Ghost_X, Ghost_Y, targetX, targetY);
            Ghost_X+=VectorX(TWA_JUMP_SPEED, angle);
            Ghost_Y+=VectorY(TWA_JUMP_SPEED, angle);
            
            // Set height based on how much of the total distance has been covered
            totalDist=Distance(startX, startY, targetX, targetY);
            currentDist=Distance(Ghost_X, Ghost_Y, targetX, targetY);
            Ghost_Z=totalDist/2*Sin(currentDist/totalDist*180);
            
            TwAWaitframe(this, ghost, startSlime, destSlime);
        } while(currentDist>1);
        
        Ghost_Z=0;
        Ghost_SetFlag(GHF_CLOCK);
        Game->PlaySound(ghost->Attributes[TWA_ATTR_LAND_SOUND]);
        return true;
    }
    
    
    void TwAWaitframe(ffc this, npc ghost, npc slime1, npc slime2)
    {
        // The slimes should be invincible, but if one becomes invalid, kill everything
        if(!slime1->isValid())
        {
            ghost->HP=0;
            if(slime2->isValid())
                slime2->HP=0;
            this->Data=0;
            Quit();
        }
        else if(!slime2->isValid())
        {
            ghost->HP=0;
            slime1->HP=0;
            this->Data=0;
            Quit();
        }
        
        // Still valid - try to keepp them alive, no matter what
        else
        {
            if(slime1->HP<32768)
                slime1->HP=32768;
            if(slime2->HP<32768)
                slime2->HP=32786;
        }
        
        // If the core is dead, kill the slimes as well
        if(!Ghost_Waitframe(this, ghost, true, false))
        {
            slime1->HP=0;
            slime2->HP=0;
            Quit();
        }
    }
}

