package entities
{
	import flash.geom.Point;
	
	import Component.Collidable;
	import Component.Displayable;
	import Component.Drawing;
	import Component.Spatial;

	public class HydrationPouch extends Entity
	{
		public function HydrationPouch(placement:Point, func:Function)
		{
			super();
			
			addComponent(new Spatial(this,placement.x, placement.y,0,0,0));
			addComponent(new Displayable(this, "WaterSpot"));
			addComponent(new Drawing(this));
			addComponent(new Collidable(this, func,1));
		}
	}
}