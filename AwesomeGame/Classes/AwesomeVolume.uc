class AwesomeVolume extends Volume
    placeable;

    enum E_LandType
    {
        Ty_ICE,
        Ty_WATER,
        Ty_LOSE,
        Ty_WIN
    };

var() E_LandType m_Type;


function PostBeginPlay()
{
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
    local AwesomePlayerController PC;
    local AwesomeHUD UI;

	if(AwesomePlayerCharacter(Other)!=none)
    {
        switch(m_Type)
        {
            case Ty_ICE:
                AwesomePlayerCharacter(Other).CurrentLandInformation = 0;
                break;
            case Ty_WATER:
                AwesomePlayerCharacter(Other).CurrentLandInformation = 1;
                break;
            case Ty_LOSE:
                AwesomePlayerCharacter(Other).CurrentLandInformation = 2;
                break;
            case Ty_WIN:
                AwesomePlayerCharacter(Other).CurrentLandInformation = 3;
                break;
        }
        
        if(m_Type == Ty_WIN)
        {
            AwesomePlayerCharacter(Other).bIsWin=true;
            PC = AwesomePlayerController(AwesomePlayerCharacter(Other).Controller);
            if(PC != none)
            {
                UI = AwesomeHUD(PC.myHUD);
                if(UI != none)
                {
                    UI.YouWin();
                }

                //PC.GameEnded();
            }
        }
        else if (m_Type == Ty_LOSE)
        {
            AwesomePlayerCharacter(Other).bIsWin=false;
            PC = AwesomePlayerController(AwesomePlayerCharacter(Other).Controller);
            if(PC != none)
            {
                UI = AwesomeHUD(PC.myHUD);
                if(UI != none)
                {
                    UI.YouLose();
                }
                //PC.GameEnded();
            }            
        }
    }
}

event untouch( Actor Other )
{
	if(AwesomePlayerCharacter(Other)!=none)
    {
        //AwesomePlayerCharacter(Other).CurrentLandInformation = -1;
    }
}

defaultproperties
{
    m_Type=Ty_ICE

    Begin Object Class=SpriteComponent Name=Sprite
        Sprite=Texture2D'EditorResources.S_NavP'
        HiddenGame=True
    End Object
    Components.Add(Sprite)
}
