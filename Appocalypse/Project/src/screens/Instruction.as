package screens
{
	import entities.HUD;
	
	import events.NavigationEvent;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	public class Instruction extends Sprite
	{
		private var mainMenuBtn:Button;
		private var background:Image;
		private var instructions:TextField;
		private var turretGunText:TextField;
		
		public function Instruction()
		{
			super();
			this.visible = false;			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			mainMenuBtn = new Button(Assets.getAtlas().getTexture("HUD_MENUBUTTON"));
			mainMenuBtn.x = 500;
			mainMenuBtn.y = 500;	
			background = new Image(Assets.getAtlas().getTexture("WELCOME_SCREEN"));			
			
			var color:Number = 0xFFFFFF;			
			turretGunText = new TextField(280,200,"Drag turrets onto the field to defend yourself. Upgrade/Switch your guns. Remember to reload your turrets!","MyFontName",24,color);
			turretGunText.x = 490;
			turretGunText.y = 175;
			
			instructions = new TextField(350,400,"You are the last survivor. You must make it to the teleporter to survive. Kill zombies to gain points and push forward to reach the next water source.","MyFontName",24,color);
			instructions.x = 450;
			instructions.y = -80;
			
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);			
		}
		
		private function onClick(e:Event):void
		{
			if(e.target as Button == mainMenuBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, {id: "main"}, true));
			}
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			stage.removeChild(mainMenuBtn);
			stage.removeChild(background);
			stage.removeChild(instructions);
			stage.removeChild(turretGunText);
			stage.removeEventListener(Event.TRIGGERED,onClick);
		}
		
		public function initialize():void
		{
			this.visible = true;
			stage.addChild(background);			
			stage.addChild(mainMenuBtn);
			stage.addChild(instructions);
			stage.addChild(turretGunText);
			stage.addEventListener(Event.TRIGGERED,onClick);
		}
	}
}