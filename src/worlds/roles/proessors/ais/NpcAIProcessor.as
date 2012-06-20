package  worlds.roles.proessors.ais
{
	import flash.geom.Point;
	import worlds.auxiliarys.MapPoint;
	import worlds.auxiliarys.mediators.MSignal;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-9
	// ============================
	public class NpcAIProcessor
	{
		private var wanderProcessor : WanderProcessor;
		private var radarProcessor : RadarProcessor;
		private var trackProcessor : TrackProcessor;
		public var sWalkTo : MSignal = new MSignal();
		public var sLockEnemy : MSignal = new MSignal();
		public var sLoseEnemy : MSignal = new MSignal();
		public var sHitEnemy : MSignal = new MSignal();
		public var updatePosition : Function;
		public var enemyUpdatePosition : Function;

		function NpcAIProcessor() : void
		{
			updatePosition = emptyUpdatePositionHander;
			enemyUpdatePosition = emptyUpdatePositionHander;
		}

		public function reset(originX : int, originY : int, pointList : Vector.<Point>, moveRadius : Number, attackRadius : Number, x : int, y : int, enemyPosition : MapPoint) : void
		{
			wanderProcessor = new WanderProcessor();
			wanderProcessor.reset(sWalkTo.dispatch, pointList, originX, originY);
			radarProcessor = new RadarProcessor();
			updatePosition = radarProcessor.updatePostion;
			enemyUpdatePosition = radarProcessor.enemyUpdatePosition;
			radarProcessor.reset(originX, originY, moveRadius, attackRadius, x, y, enemyPosition.x, enemyPosition.y, sLockEnemy.dispatch, sLoseEnemy.dispatch, hit);
			trackProcessor = new TrackProcessor();
			trackProcessor.reset(originX, originY, enemyPosition, sWalkTo.dispatch);
			// 锁定
			sLockEnemy.add(trackProcessor.start);
			sLockEnemy.add(wanderProcessor.stop);
			// 失去
			sLoseEnemy.add(trackProcessor.stop);
			sLoseEnemy.add(trackProcessor.retreat);
			sLoseEnemy.add(wanderProcessor.start);
			if (moveRadius == 0)
			{
				wanderProcessor.stop();
				trackProcessor.stop();

				sLoseEnemy.remove(trackProcessor.stop);
				sLoseEnemy.remove(trackProcessor.retreat);

				sLockEnemy.remove(trackProcessor.start);
				sLockEnemy.remove(wanderProcessor.stop);
			}
		}

		public function destory() : void
		{
			sWalkTo.clear();
			sLockEnemy.clear();
			sLoseEnemy.clear();
			sHitEnemy.clear();
			wanderProcessor.destory();
			radarProcessor.destory();
			wanderProcessor = null;
			radarProcessor = null;
			trackProcessor = null;
		}

		private function emptyUpdatePositionHander(x : int, y : int) : void
		{
		}

		public function start() : void
		{
			wanderProcessor.start();
			radarProcessor.start();
		}

		public function stop() : void
		{
			wanderProcessor.stop();
			radarProcessor.stop();
			trackProcessor.stop();
		}

		private function hit() : void
		{
			trace("AI_HIT");
			stop();
			sHitEnemy.dispatch();
		}

	}
}
