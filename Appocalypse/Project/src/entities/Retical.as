package entities
{
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import Component.Displayable;
	import Component.Drawing;
	import Component.Spatial;
	
	import screens.Game;
	
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Retical extends Entity
	{
		private var lastTouchPosition:Point;
		public function Retical()
		{
			super();
			
			addComponent(new Spatial(this,0,0,0,0,0));
			addComponent(new Displayable(this,"reticle"));
			addComponent(new Drawing(this));
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, onTouch);
			lastTouchPosition = new Point(1000,0);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			// TODO Auto Generated method stub
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.ENDED || Game.time == Game.DAY_TIME)
			{
				if(Mouse.supportsCursor)
					Mouse.show();
				
				lastTouchPosition.y = -100;
			}
			else
			{
				if(Mouse.supportsCursor)
					Mouse.hide();
				
				var s:Spatial = Spatial(getComponent("Spatial"));
				s.worldX = Game.screenToWorldX + touch.globalX;
				s.worldY = Game.screenToWorldY + touch.globalY;
				lastTouchPosition = new Point(touch.globalX, touch.globalY);
			}
		}
		
		public override function dispose():void
		{
			super.dispose();
			
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function updatePosition():void
		{
			var spatial:Spatial = Spatial(getComponent("Spatial"));
			if(spatial!=null)
			{
				//maybe 
				spatial.worldX = Game.screenToWorldX + lastTouchPosition.x;
				spatial.worldY = Game.screenToWorldY + lastTouchPosition.y;
			}
		}
	}
}