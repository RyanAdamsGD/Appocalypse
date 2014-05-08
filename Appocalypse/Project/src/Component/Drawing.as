package Component
{
	import entities.Entity;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	public class Drawing extends Component
	{
		public var sprite:DisplayObject;
		public static var Drawables:Vector.<Drawing> = new Vector.<Drawing>;
		private var _draw:Boolean
		private var imageLevel:int;
		public function Drawing(parent:Entity,imageLevel:int = 1)
		{
			super("Drawing", parent);
			sprite = Displayable(getComponent("Displayable")).sprite;
			this.imageLevel = imageLevel;
			
			Spatial(getComponent("Spatial")).height = Displayable(getComponent("Displayable")).height;
			Spatial(getComponent("Spatial")).width = Displayable(getComponent("Displayable")).width;
			Starling.current.stage.addChildAt(sprite,imageLevel);
			draw = true;
			
			Drawables.push(this);
		}
		
		private function onDraw():void
		{
			var spatial:Spatial = Spatial(getComponent("Spatial"));
			if(spatial != null)
			{
				sprite.x = spatial.screenX;
				sprite.y = spatial.screenY;
				sprite.width = spatial.width;
				sprite.height = spatial.height;
				sprite.rotation = spatial.rotation;
				
				if(spatial.screenX > -spatial.width && spatial.screenX < Starling.current.stage.stageWidth && spatial.screenY > -spatial.height && spatial.screenY < Starling.current.stage.stageHeight)
				{
					sprite.visible = true;
					if(!Starling.current.stage.contains(sprite))
						Starling.current.stage.addChildAt(sprite,imageLevel);
				}
				else
				{
					sprite.visible = false;
					if(Starling.current.stage.contains(sprite))
						Starling.current.stage.removeChild(sprite);
				}
					
			}
		}
		override public function cleanUp():void
		{
			for( var i:int = 0; i < Drawables.length; i++)
			{
				if(Drawables[i] == this)
				{
					Drawables[i].sprite.dispose();
					Starling.current.stage.removeChild(Drawables[i].sprite);
					Drawables.splice(i--, 1);
				}
			}
			Starling.current.stage.removeChild(sprite);
		}
		public static function update():void
		{
			for( var i:int = 0; i < Drawables.length; i++)
			{
				var where:Drawing = Drawables[i];
				if(where == null)
					Drawables.splice(i--, 1);
				else if(where.draw)
						where.onDraw();
			}
		}

		public function get draw():Boolean
		{
			return _draw;
		}

		public function set draw(value:Boolean):void
		{
			_draw = value;
		}

	}
}