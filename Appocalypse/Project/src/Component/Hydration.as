package Component
{
	import entities.Entity;
	
	import screens.Game;
	
	public class Hydration extends Component
	{
		private var _MAX_HYDRATION:Number;
		private var _dehydrationRate:Number;
		private var _currentHydration:Number;
		private var lossPerDay:Number;
		private var lossPerNight:Number;
		private var calledOnceToday:Boolean;
		private var lossTime:Number;
		public function Hydration(parent:Entity, MaxHydration:Number, lossPerDay:Number)
		{
			super("Hydration" , parent);
			MAX_HYDRATION = MaxHydration;
			dehydrationRate = lossPerDay;
			this.lossPerDay = lossPerDay/15;
			this.lossPerNight = lossPerDay/45;
			lossTime = 0;
			currentHydration = MaxHydration;
			calledOnceToday = false;
		}
		
		public function update(dt:Number):void
		{
			lossTime += dt;
			if(Game.time == Game.NIGHT_TIME && lossTime>1)
			{
				currentHydration -= lossPerNight;
				//currentHydration -= dehydrationRate;
			}
			if(Game.time == Game.DAY_TIME && lossTime>1)
			{
				currentHydration -= lossPerDay;
			}
			if(lossTime >1)
				lossTime = 0;
		}

		public function get currentHydration():Number
		{
			return _currentHydration;
		}

		public function set currentHydration(value:Number):void
		{
			_currentHydration = value;
		}

		public function get MAX_HYDRATION():Number
		{
			return _MAX_HYDRATION;
		}

		public function set MAX_HYDRATION(value:Number):void
		{
			_MAX_HYDRATION = value;
		}

		public function get dehydrationRate():Number
		{
			return _dehydrationRate;
		}

		public function set dehydrationRate(value:Number):void
		{
			_dehydrationRate = value;
		}


	}
}