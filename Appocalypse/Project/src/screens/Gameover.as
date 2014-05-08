package screens
{
	import events.NavigationEvent;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class Gameover extends Sprite
	{
		private var mainMenuBtn:Button;
		private var retyBtn:Button;
		private var background:Image;
		
		private var Credits:TextField;
		private var SoundSources:TextField;
		
		public function Gameover()
		{
			super();
			this.visible = false;
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			var color:Number = 0x000000;
			Credits = new TextField(280,400,"Credits: \n\nSprite Sources:\nOpenGameArt.org\nIronstarmedia.co.uk\n","MyFontName",24,color,true);
			Credits.x = 500;
			Credits.y = 10;
			Credits.hAlign = HAlign.CENTER;
			
			SoundSources = new TextField(280,400,"Sound Effect Sources:\nSoundBible.com\nSoundJay.com\nSharma.com\nGamethemesongs.com\nFreemusicarchive.com","MyFontName",24,color,true);
			SoundSources.x = 500;
			SoundSources.y = 200;
			SoundSources.hAlign = HAlign.CENTER;
			
			mainMenuBtn = new Button(Assets.getAtlas().getTexture("HUD_MENUBUTTON"));
			mainMenuBtn.x = 350;
			mainMenuBtn.y = 200;
			retyBtn = new Button(Assets.getAtlas().getTexture("HUD_RETRYBUTTON"));
			retyBtn.x = 350;
			retyBtn.y = 300;
			background = new Image(Assets.getAtlas().getTexture("GAMEOVER_SCREEN"));
		}
		
		private function onClick(e:Event):void
		{
			if(e.target as Button == retyBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "game"}, true));
			}
			else if(e.target as Button == mainMenuBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "main"}, true));
			}
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			stage.removeChild(background);
			stage.removeChild(mainMenuBtn);
			stage.removeChild(retyBtn);
			stage.removeChild(Credits);
			stage.removeChild(SoundSources);
			stage.removeEventListener(Event.TRIGGERED,onClick);
		}
		
		public function initialize():void
		{
			this.visible = true;		
			stage.addChild(background);
			stage.addChild(mainMenuBtn);
			stage.addChild(retyBtn);
			stage.addChild(Credits);
			stage.addChild(SoundSources);
			stage.addEventListener(Event.TRIGGERED,onClick);
		}
	}
}