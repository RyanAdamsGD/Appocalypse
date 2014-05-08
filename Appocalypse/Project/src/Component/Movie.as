package Component
{
	import flash.geom.Point;
	
	import entities.Entity;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	public class Movie extends Component
	{
		private var _movie:MovieClip;
		public static var Movies:Vector.<Movie> = new Vector.<Movie>;
		private var _draw:Boolean
		private var imageLevel:int;
		private var fps:Number;
		private var paused:Boolean;
		private var lastPoint:Point;
		
		public function Movie(parent:Entity,imageLevel:int = 1)
		{
			super("Movie", parent);
			var displayable:Displayable =Displayable(getComponent("Displayable"));
			if(displayable.isMovie)
			{
				movie = displayable.movie;
				this.fps = movie.fps;
			}
			else
				throw new Error("Not a movie!");
			this.imageLevel = imageLevel;
			
			Spatial(getComponent("Spatial")).height = Displayable(getComponent("Displayable")).height;
			Spatial(getComponent("Spatial")).width = Displayable(getComponent("Displayable")).width;
			Starling.current.stage.addChildAt(movie,imageLevel);
			lastPoint = new Point();
			draw = true;
			paused = false;
			Movies.push(this);
		}
		
		private function onDraw():void
		{
			var spatial:Spatial = Spatial(getComponent("Spatial"));
			if(spatial != null)
			{
				if(lastPoint.x == spatial.worldX && lastPoint.y == spatial.worldY)
				{
					movie.pause();
					paused = true;
				}
				else if(paused)
				{
					movie.play();
					paused = false;
				}
				movie.x = spatial.screenX;
				movie.y = spatial.screenY;
				movie.width = spatial.width;
				movie.height = spatial.height;
				movie.rotation = spatial.rotation;
				
				if(spatial.screenX > -spatial.width && spatial.screenX < Starling.current.stage.stageWidth && spatial.screenY > -spatial.height && spatial.screenY < Starling.current.stage.stageHeight)
				{
					movie.visible = true;
					if(!Starling.current.stage.contains(movie))
						Starling.current.stage.addChildAt(movie,imageLevel);
				}
				else
				{
					movie.visible = false;
					if(Starling.current.stage.contains(movie))
						Starling.current.stage.removeChild(movie);
				}
				
				lastPoint = new Point(spatial.worldX, spatial.worldY);
			}
		}
		override public function cleanUp():void
		{
			for( var i:int = 0; i < Movies.length; i++)
			{
				if(Movies[i] == this)
				{
					Movies[i].movie.dispose();
					Starling.current.stage.removeChild(Movies[i].movie);
					Movies.splice(i--, 1);
				}
			}
			Starling.current.stage.removeChild(movie);
		}
		public static function update():void
		{
			for( var i:int = 0; i < Movies.length; i++)
			{
				var where:Movie = Movies[i];
				if(where == null)
					Movies.splice(i--, 1);
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

		public function get movie():MovieClip
		{
			return _movie;
		}

		public function set movie(value:MovieClip):void
		{
			value.fps = 6;
			starling.core.Starling.juggler.add(value);
			_movie = value;
		}
		
		
	}
}