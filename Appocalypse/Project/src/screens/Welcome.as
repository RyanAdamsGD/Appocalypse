package screens
{	
	import events.NavigationEvent;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Welcome extends Sprite
	{
		private var startBtn:Button;
		private var instructionBtn:Button;
		private var background:Image;
		
		public function Welcome()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			background = new Image(Assets.getAtlas().getTexture("WELCOME_SCREEN"));
			stage.addChild(background);
			startBtn = new Button(Assets.getAtlas().getTexture("HUD_STARTBUTTON"));
			startBtn.x = 500;
			startBtn.y = 300;
			stage.addChild(startBtn);
			instructionBtn = new Button(Assets.getAtlas().getTexture("HUD_INSTRUCTIONSBUTTON"));
			instructionBtn.x = 500;
			instructionBtn.y = 400;
			stage.addChild(instructionBtn);
			stage.addEventListener(Event.TRIGGERED,onClick);
		}
		
		private function onClick(e:Event):void
		{
			if(e.target as Button == instructionBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "instruction"}, true));
			}
			else if(e.target as Button == startBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "game"}, true));
			}
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			stage.removeChild(startBtn);
			stage.removeChild(instructionBtn);
			stage.removeChild(background);
			stage.removeEventListener(Event.TRIGGERED,onClick);
		}
		
		public function initialize():void
		{
			this.visible = true;
			stage.addChild(background);
			stage.addChild(startBtn);
			stage.addChild(instructionBtn);
			stage.addEventListener(Event.TRIGGERED,onClick);
		}
	}
}