package entities
{
	import flash.geom.Point;
	
	import Component.Displayable;
	import Component.Drawing;
	import Component.Spatial;

	public class ZombieSpawner extends Entity
	{
		
		public function ZombieSpawner(loc:Point)
		{
			super();
			addComponent(new Spatial(this, loc.x, loc.y, 0, 0, 0));
			addComponent(new Displayable(this, "GOAL"));
			addComponent(new Drawing(this));
			Spatial(getComponent("Spatial")).worldY = loc.y - (Displayable(getComponent("Displayable")).height - 20);
			Spatial(getComponent("Spatial")).worldX = loc.x - ((Displayable(getComponent("Displayable")).width/2)-20);
		}
	}
}