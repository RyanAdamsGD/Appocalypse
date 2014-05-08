package Component
{
	import flash.ui.Keyboard;
	
	import entities.Entity;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class Directional extends Component
	{
		private var sprite:MovieClip;
		private var image:Sprite;
		private var isMovie:Boolean;
		private var east:String, west:String, north:String, south:String;
		private var northEast:String = null, southEast:String = null, southWest:String = null, northWest:String = null;
		private var A:Boolean, D:Boolean, S:Boolean, W:Boolean;
		private var hasChanged:Boolean;
		public function Directional(parent:Entity, east:String, west:String, north:String, south:String, northEast:String = null, southEast:String = null, southWest:String = null, northWest:String = null)
		{
			super("Directional", parent);
			
			this.east = east;
			this.west = west;
			this.south = south;
			this.north = north;
			this.northWest = northWest;
			this.northEast = northEast;
			this.southEast = southEast;
			this.southWest = southWest;
			
			A,D,S,W = false;
			isMovie = false;
			hasChanged = false;
			var displayable:Displayable = Displayable(getComponent("Displayable"));
			
			if(displayable)
			{
				isMovie = true;
				if(isMovie)
					sprite = displayable.movie;
				else
					image = displayable.sprite;
			}
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			Starling.current.stage.addEventListener(Event.ENTER_FRAME, onFrameEnter);
		}
		
		private function onFrameEnter():void
		{
			if(A && hasChanged)
			{
				if(isMovie)
					sprite = new MovieClip(Assets.getAtlas().getTextures(west));
				else
					image.addChild(new Image(Assets.getAtlas.getTexture(west)));
			}
			if(D && hasChanged)
			{
				if(isMovie)
					sprite = new MovieClip(Assets.getAtlas().getTextures(east));
				else
					image.addChild(new Image(Assets.getTexture(east)));
			}
			if(W && hasChanged)
			{
				if(isMovie)
					sprite = new MovieClip(Assets.getAtlas().getTextures(north));
				else
					image.addChild(new Image(Assets.getTexture(north)));
			}
			if(S && hasChanged)
			{
				if(isMovie)
					sprite = new MovieClip(Assets.getAtlas().getTextures(south));
				else
					image.addChild(new Image(Assets.getTexture(south)));
			}
			var movieComp:Movie = Movie(getComponent("Movie"));
			
			if(movieComp && hasChanged)
			{
				Starling.current.stage.removeChild(movieComp.movie);
				movieComp.movie = sprite;
				hasChanged = false;
			}
		}
		
		private function onKeyPress(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.A)
			{
				hasChanged = !A;
				A = true;
			}
			if(e.keyCode == Keyboard.D)
			{
				hasChanged = !D;
				D = true;
			}
			if(e.keyCode == Keyboard.W)
			{
				hasChanged = !W;
				W = true;
			}
			if(e.keyCode == Keyboard.S)
			{	
				hasChanged = !S;
				S = true;
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.A)
			{
				A = false;
			}
			if(e.keyCode == Keyboard.D)
			{
				D = false;
			}
			if(e.keyCode == Keyboard.W)
			{
				W = false;
			}
			if(e.keyCode == Keyboard.S)
			{
				S = false;
			}
		}
	}
}