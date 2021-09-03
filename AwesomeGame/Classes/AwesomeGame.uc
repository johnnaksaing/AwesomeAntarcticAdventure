class AwesomeGame extends UDKGame;

var bool bIsGameOver;

var AudioComponent BackgroundMusic;
var SoundCue YouWinSound;

function PostBeginPlay()
{
    BackgroundMusic.Play();
    `log("AwesomeGame : this game is Awesome!!");
}

function GameOver()
{
    //stop music
    BackgroundMusic.Stop();
    //`log("AwesomeGame : this game is Awesome!!");
}

function GameRestart()
{
    //stop music
    BackgroundMusic.Play();
    //`log("AwesomeGame : this game is Awesome!!");
}

function YouWin()
{
    if(!bIsGameOver)
    {
        //BackgroundMusic.Stop();
        PlaySound(YouWinSound);
        bIsGameOver = true;
    }
}

defaultproperties
{
    Begin Object Class=AudioComponent Name=MusicComp
        SoundCue=MyPackage.A_bgm_main               
    End Object

    BackgroundMusic = MusicComp    

    YouWinSound = SoundCue'MyPackage.A_YouWin'  

    PlayerControllerClass=class'AwesomeGame.AwesomePlayerController'
    DefaultPawnClass=class'AwesomeGame.AwesomePlayerCharacter'
    bIsGameOver=false
}