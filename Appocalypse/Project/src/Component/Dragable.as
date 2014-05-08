package Component
{
	import flash.geom.Point;
	
	import entities.Entity;
	
	import screens.Game;
	
	import starling.display.Stage;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Dragable extends Component
	{
		private var pickedUp:Boolean;
		private var stage:Stage;
		private var placed:Boolean;
		
		public function Dragable(stage:Stage, parent:Entity)
		{
			super("Dragable", parent);
			pickedUp = false;
			placed = false;
			this.stage = stage;
			this.stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var spatial:Spatial = Spatial(getComponent("Spatial"));
			if(e.touches[0].phase == TouchPhase.BEGAN)
			{
				var touchPoint:Point = new Point();//
				e.touches[0].getLocation(stage,touchPoint);
				
				if(spatial.getScreenRect().containsPoint(touchPoint))
				{
					pickedUp = true;
				}
				//Begin touch or pick up
			}
			if(e.touches[0].phase == TouchPhase.MOVED)			
			{
				if(pickedUp && !placed)
				{
					var x:Number = e.touches[0].globalX - spatial.width/2;
					var y:Number =  e.touches[0].globalY - spatial.height/2;
					if(x > 0 && x < stage.stageWidth - spatial.width)
						spatial.worldX = x + Game.screenToWorldX;
					if(y > 0 && y < stage.stageHeight - spatial.height)
						spatial.worldY = y + Game.screenToWorldY;
				}
			}
			if(e.touches[0].phase == TouchPhase.ENDED || Game.time == Game.NIGHT_TIME)
			{
				pickedUp = false;
				placed = true;
				//Drop or end touch
			}
		}
	}
}