package entities
{
	import starling.events.Event;
	
	public interface IMapPiece
	{
		function onAddedToStage(event:Event):void;
		
		function get GETWIDTH():Number;
		function set SETWIDTH(value:Number):void;
		function get GETHEIGHT():Number;
		function set SETHEIGHT(value:Number):void;
		function get GETX():Number;
		function set SETX(value:Number):void;
		function get GETY():Number;
		function set SETY(value:Number):void;
	}
}