package entities
{
	import Component.Displayable;
	import Component.Spatial;
	
	import starling.core.Starling;

	public class Hud_StatBar extends Entity
	{
		private var display:Displayable;
		public function Hud_StatBar()
		{
			display = new Displayable(this, "HUD_STATBAR");
			addComponent(display);
			addComponent(new Spatial(this,0,0,0,0,0));
			Starling.current.stage.addChildAt(display.sprite,2);
		}
		public function visible(value:Boolean):void
		{
			display.visible(value);			
		}
	}
}