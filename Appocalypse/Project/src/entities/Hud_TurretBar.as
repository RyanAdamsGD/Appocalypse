package entities
{
	import Component.Displayable;
	import Component.Spatial;
	
	import starling.core.Starling;

	public class Hud_TurretBar extends Entity
	{
		private var display:Displayable;
		public function Hud_TurretBar()
		{
			display = new Displayable(this, "HUD_TURRETBAR");
			addComponent(display);
			addComponent(new Spatial(this,0,0,0,0,0));
			Starling.current.stage.addChild(display.sprite);
		}
		public function visible(value:Boolean):void
		{
			display.visible(value);			
		}
	}
}