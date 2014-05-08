package
{
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import net.hires.debug.Stats;
	
	import screens.Game;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60", width="800", height="600", backgroundColor="0x333333")]
	public class TowerOffense extends Sprite
	{
		private var stats:Stats;
		private var myStarling:Starling;
		public function TowerOffense()
		{
//			var myVideo:Video = new Video();
//			addChild(myVideo);
//			
//			var nc:NetConnection = new NetConnection();
//			nc.connect(null);
//			var ns:NetStream = new NetStream(nc);
//			ns.client = new Object();
//			myVideo.attachNetStream(ns);
//			ns.play("http://www.helpexamples.com/flash/video/cuepoints.flv");
			
			
			myStarling= new Starling(InGame, stage);
			
			myStarling.antiAliasing = 1;
			myStarling.start();
		}
		
		
	}
}