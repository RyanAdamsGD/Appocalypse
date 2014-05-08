package
{
	
	import flash.ui.Mouse;
	
	import events.NavigationEvent;
	
	import screens.Game;
	import screens.Gameover;
	import screens.Instruction;
	import screens.Welcome;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class InGame extends Sprite
	{
		private var gameoverScreen:Gameover;
		private var instructionScreen:Instruction;
		private var gameScreen:Game;
		private var welcomeScreen:Welcome;
		
		public function InGame()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			// TODO Auto Generated method stub
			trace("initialized starling framework");
			
			this.addEventListener(events.NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			
			gameScreen = new Game();
			this.addChild(gameScreen);
			
			gameoverScreen = new Gameover();
			this.addChild(gameoverScreen);
			
			instructionScreen = new Instruction();
			this.addChild(instructionScreen);
			
			welcomeScreen = new Welcome();
			this.addChild(welcomeScreen);
			welcomeScreen.initialize()
		}
		
		public function onChangeScreen(event:NavigationEvent):void
		{
			switch(event.params.id)
			{
				case "main":
					welcomeScreen.initialize();
					gameScreen.disposeTemporarily();
					gameoverScreen.disposeTemporarily();
					instructionScreen.disposeTemporarily();
					Mouse.show();
					break;
				case "instruction":
					welcomeScreen.disposeTemporarily();
					gameScreen.disposeTemporarily();
					gameoverScreen.disposeTemporarily();
					instructionScreen.initialize();
					Mouse.show();
					break;
				case "gameover":
					welcomeScreen.disposeTemporarily();
					gameScreen.disposeTemporarily();
					gameoverScreen.initialize();
					instructionScreen.disposeTemporarily();
					Mouse.show();
					break;
				case "game":
					welcomeScreen.disposeTemporarily();
					gameScreen.initialize();
					gameoverScreen.disposeTemporarily();
					instructionScreen.disposeTemporarily();
					break;
				
			}
		}
		
	}
}