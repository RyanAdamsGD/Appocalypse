package Component
{
	import entities.Entity;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	
	public class Displayable extends Component
	{
		private var _image:Image;
		private var _sprite:Sprite;
		private var _movie:MovieClip;
		private var _isImage:Boolean;
		private var _isMovie:Boolean;
		public function Displayable(parent:Entity, imageName:String = null, movieName:String = null, fps:uint = 60)
		{
			super("Displayable", parent);
			if(imageName !=null)
			{
				sprite = new Sprite();
				_image = new Image(Assets.getAtlas().getTexture(imageName));
				sprite.name = imageName;
				isImage = true;
				sprite.addChild(image);
			}
			if(movieName !=null)
			{
				isMovie = true;
				movie = new MovieClip(Assets.getAtlasTextures(movieName),fps);
			}
			var spatial:Spatial = Spatial(getComponent("Spatial"));
			if(spatial != null)
			{
				if(isImage)
					sprite.rotation = spatial.rotation;
				if(isMovie)
					movie.rotation = spatial.rotation;
				//image.x = spatial.worldX;
				//image.y = spatial.worldY;
			}
			
		}

		override public function cleanUp():void
		{
			if(isImage)
			{
				sprite.removeChild(image,true);
				Starling.current.stage.removeChild(sprite);
			}
			if(isMovie)
			{
				movie.removeFromParent(true);
				Starling.current.stage.removeChild(movie);
			}
		}
		
		public function visible(value:Boolean):void
		{
			if(isImage)
				sprite.visible = value;
			if(isMovie)
				movie.visible = value;
		}
		
		public function get height():Number
		{
			var value:Number = 30;
			if(isImage)
				value = image.height;
			if(isMovie)
				value = movie.height;
			return value;
		}
		
		public function set height(value:Number):void
		{
			if(isImage)
				image.height = value;
			if(isMovie)
				movie.height = value;
		}

		public function get width():Number
		{
			var value:Number = 30;
			if(isImage)
				value = image.width;
			if(isMovie)
				value = movie.width;
			return value;
		}
		
		public function set width(value:Number):void
		{
			if(isImage)
				image.width = value;
			if(isMovie)
				movie.width = value;
		}

		public function get sprite():Sprite
		{
			return _sprite;
		}

		public function set sprite(value:Sprite):void
		{
			_sprite = value;
		}

		public function get image():Image
		{
			return _image;
		}

		public function get movie():MovieClip
		{
			return _movie;
		}

		public function set movie(value:MovieClip):void
		{
			_movie = value;
		}

		public function get isImage():Boolean
		{
			return _isImage;
		}

		public function set isImage(value:Boolean):void
		{
			_isImage = value;
		}

		public function get isMovie():Boolean
		{
			return _isMovie;
		}

		public function set isMovie(value:Boolean):void
		{
			_isMovie = value;
		}


	}
}