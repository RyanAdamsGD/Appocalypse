package entities
{
	import flash.geom.Rectangle;
	
	import Component.Displayable;
	import Component.Drawing;
	import Component.Spatial;

	public class PlayerGoalLocation extends Entity
	{
		private var _setHeight:Number;
		private var _setWidth:Number;
		private var _setX:Number;
		private var _setY:Number;
		private var PieceLocation:Rectangle;
		
		public function PlayerGoalLocation() 
		{
			super();
			addComponent(new Spatial(this,-5700,550,96,172,0));
			addComponent(new Displayable(this,"spawner"));
			addComponent(new Drawing(this));
		}		
	}
}