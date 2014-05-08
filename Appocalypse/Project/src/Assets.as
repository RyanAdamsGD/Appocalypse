package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		private static var gameTextureAtlas:TextureAtlas;
		
		[Embed(source="../../Assets/MySpritesheet.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source="../../Assets/MySpritesheet.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		[Embed(source="../../Assets/Fonts/times.ttf", fontFamily="MyFontName", embedAsCFF="false")]
		public static var MyFont:Class;
		
		private static var gameTextures:Dictionary = new Dictionary();
		
		public static function getAtlasTextures(name:String):Vector.<Texture>
		{
			var textures:Vector.<Texture> = getAtlas().getTextures(name);
			return textures;
		}
		
		public static function getAtlas():TextureAtlas
		{
			if(gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("AtlasTextureGame");
				var xml:XML = XML(new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture,xml);
			}
			return gameTextureAtlas;
		}
		
		public static function getTexture(name:String):Texture
		{
			if(gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap);
			}
			return gameTextures[name];
		}
		
		public function Assets()
		{
		}
	}
}