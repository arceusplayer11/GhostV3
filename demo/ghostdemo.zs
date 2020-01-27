//Updated 27th January, 2020

#include "std.zh"
#include "ghost.zh"

#include "ghzhDemo/SimpleGhostZHExample.zs"
#include "ghzhDemo/Dragon.zs"
#include "ghzhDemo/TwinAmoeba.zs"
#include "ghzhDemo/Lich.zs"
#include "ghzhDemo/Iflyte.zs"
#include "ghzhDemo/Julius.zs"
#include "ghzhDemo/Grell.zs"


// Since the script-spawned Triforce doesn't get
// held up automatically...
item script holdup
{
	void run()
	{
		Link->Action=LA_HOLD2LAND;
		Link->HeldItem=20;
	}
}



// Just an extra little detail. Destroy the statues in Iflyte's room if he hits them.
ffc script DestroyStatues
{
	void run()
	{
		ffc iflyte=Screen->LoadFFC(1);

		if(Screen->D[0]>0)
		{
			Game->SetComboData(1, 0x31, 99, 0);
			Screen->ComboD[115]=134;
		}

		if(Screen->D[1]>0)
		{
			Game->SetComboData(1, 0x31, 108, 0);
			Screen->ComboD[124]=134;
		}

		while(true)
		{
			if(Screen->D[0]==0 && iflyte->X<60 && iflyte->Y>84)
			{
				Game->PlaySound(SFX_BOMB);
				Game->SetComboData(1, 0x31, 99, 0);
				Screen->ComboD[115]=134;
				Screen->D[0]=1;
			}

			if(Screen->D[1]==0 && iflyte->X>164 && iflyte->Y>84)
			{
				Game->PlaySound(SFX_BOMB);
				Game->SetComboData(1, 0x31, 108, 0);
				Screen->ComboD[124]=134;
				Screen->D[1]=1;
			}

			Waitframe();
		}
	}
}
