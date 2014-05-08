package entities
{
	import flash.geom.Point;
	
	import Component.Displayable;
	import Component.Drawing;
	import Component.Spatial;

	public class Trees extends Entity
	{
		public function Trees(source:Point,type:int = 1)
		{
			super();
			addComponent(new Spatial(this, source.x, source.y, 0, 0, 0));
			
			if(type >4 || type < 1)
				type = 1;
			
			addComponent(new Displayable(this, "TREE_"+type));
			var draw:Drawing = new Drawing(this);
			//draw.draw = false;
			addComponent(draw);
		}
	}
}