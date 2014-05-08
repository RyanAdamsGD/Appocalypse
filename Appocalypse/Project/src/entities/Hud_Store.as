package entities
{
	import Component.Displayable;
	import Component.Spatial;
	
	import starling.core.Starling;

	public class Hud_Store extends Entity
	{
		private var display:Displayable;
		public function Hud_Store()
		{	
			addComponent(new Spatial(this,600,400,100,500,0));
			display = new Displayable(this, "HUD_STORE");
			display.image.x = 535;
			display.image.y = 425;
			addComponent(display);
			Starling.current.stage.addChild(display.sprite);
		}
		
		public function visible(value:Boolean):void
		{
			display.visible(value);			
		}
	}
}