package entities
{	
	import Component.Collidable;
	import Component.Directional;
	import Component.Displayable;
	import Component.Hydration;
	import Component.Living;
	import Component.Movie;
	import Component.Spatial;
	
	import events.CollisionEvent;
	
	import screens.Game;
	
	import starling.core.Starling;

	public class Player extends Entity
	{
		public static var shootSpeed:Number = .2;
		
		public function Player()
		{
			super();
			addComponent(new Spatial(this, Starling.current.stage.stageWidth/2,Starling.current.stage.stageHeight/2,30,37,0));//TODO magic numbers
			addComponent(new Displayable(this, null,"PLAYER_DOWN_",6));
			addComponent(new Movie(this,1));
			addComponent(new Living(this,5));
			addComponent(new Collidable(this,hitSomething));
			addComponent(new Hydration(this,100, 5));
			addComponent(new Directional(this, "PLAYER_RIGHT_","PLAYER_LEFT_","PLAYER_UP_","PLAYER_DOWN_"));
		}
		private function hitSomething(e:CollisionEvent):void
		{
		}
		
		public override function dispose():void
		{
			Sounds.sndPlayerKilled.play(0,0,Sounds.Transform);
			Game.resettingCamera = true;
			super.dispose();
		}
	}
}