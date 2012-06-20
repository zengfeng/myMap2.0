package worlds.roles.animations.depths
{
	import worlds.maps.MaskInstance;

	import game.core.avatar.AvatarThumb;

	import worlds.maps.RoleLayerMediator;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-20 ����10:33:44
	 */
	public class RoleNode
	{
		public var pre : RoleNode;
		public var next : RoleNode;
		protected var name : String;
		protected var x : int;
		protected var y : int;
		public var avatar : AvatarThumb;
		private static var linkList : RoleLinkList = RoleLinkList.instance;
		private var tempIndex : int;
		private var tempIsChange : Boolean;
		private var tempParent : DisplayObjectContainer;
		private var tempPreAvatar : DisplayObject;
		public var addToLayer : Function;
		public var removeFromLayer : Function;
		protected var updateDepth : Function;
		protected var updateMask : Function;
		private var needMask : Boolean;

		public function RoleNode()
		{
			addToLayer = emptyFun;
			removeFromLayer = emptyFun;
			updateDepth = emptyFun;
			updateMask = emptyFun;
		}
		
		public function destory():void
		{
			addToLayer = emptyFun;
			removeFromLayer = emptyFun;
			updateDepth = emptyFun;
			updateMask = emptyFun;
			needMask = false;
		}

		public function compare(node : RoleNode) : int
		{
			return y - (node ? node.y : 0);
		}

		public function toString() : String
		{
			return  "name" + name + "  y=" + y;
		}

		private function emptyFun() : void
		{
		}

		protected function setAvatar(avatar : AvatarThumb) : void
		{
			this.avatar = avatar;
			addToLayer = addToLayerHander;
			removeFromLayer = removeFromLayerHander;
		}

		private function addToLayerHander() : void
		{
			if (pre || next || linkList.head == this)
			{
				removeFromLayerHander();
			}

			tempIndex = linkList.sortAdd(this);
			RoleLayerMediator.cAdd.call(avatar, tempIndex);
			tempParent = avatar.parent;
			updateDepth = updateDepthHander;
			if (needMask)
			{
				updateMask = updateMaskHander;
				updateMask();
			}
		}

		private function removeFromLayerHander() : void
		{
			linkList.remove(this);
			updateDepth = emptyFun;
			updateMask = emptyFun;
			RoleLayerMediator.cRemove.call(avatar);
			tempParent = null;
		}

		private function updateDepthHander() : void
		{
			tempIsChange = linkList.sortUpdate(this);
			if (tempIsChange == false) return;
			if (pre)
			{
				tempPreAvatar = pre.avatar;
				tempIndex = tempParent.getChildIndex(tempPreAvatar) + 1;
			}
			else
			{
				tempIndex = 0;
			}
			RoleLayerMediator.cChangeDepth.call(avatar, tempIndex);
		}

		public function setNeedMask(value : Boolean) : void
		{
			needMask = value;
			if (needMask && tempParent)
			{
				updateMask = updateMaskHander;
				updateMask();
			}
			else
			{
				updateMask = emptyFun;
			}
		}

		private function updateMaskHander() : void
		{
			if (MaskInstance.isMask(x, y))
			{
				avatar.alpha = 0.5;
			}
			else
			{
				avatar.alpha = 1;
			}
		}
	}
}
