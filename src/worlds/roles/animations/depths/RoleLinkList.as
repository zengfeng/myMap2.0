package worlds.roles.animations.depths
{
	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012 2012-2-17 ����3:07:58
	 * 双向非循环链表
	 */
	public class RoleLinkList
	{
		/** 单例对像 */
		private static var _instance : RoleLinkList;

		/** 获取单例对像 */
		static public function get instance() : RoleLinkList
		{
			if (_instance == null)
			{
				_instance = new RoleLinkList(new Singleton());
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		public var head : RoleNode;
		protected var tail : RoleNode;
		protected var _length : uint;

		function RoleLinkList(singleton : Singleton) : void
		{
		}

		/** 添加 */
		private function add(node : RoleNode, index : int = -1) : void
		{
			if (node == null) return;
			if (index > length)
			{
				throw new Error("LinkList::addNode 参数出错(index 大于 length)");
				return;
			}

			if (head == null)
			{
				head = node;
				tail = node;
				node.pre = null;
				node.next = null;
				_length++;
				return;
			}

			var preNode : RoleNode;
			var nextNode : RoleNode;
			if (index == 0)
			{
				preNode = null;
				nextNode = head;
				head = node;
			}
			else if (index == -1 || index == length)
			{
				preNode = tail;
				nextNode = null;
				tail = node;
			}
			else
			{
				preNode = getByIndex(index - 1);
				nextNode = preNode.next;
			}

			if (preNode != null)
			{
				preNode.next = node;
			}
			node.pre = preNode;
			node.next = nextNode;
			if (nextNode != null && nextNode != head)
			{
				nextNode.pre = node;
			}
			_length++;
		}

		/** 移除 */
		public function remove(node : RoleNode) : void
		{
			if (node.next == null && node.pre == null && head != node) return;
			if (node == null) return;
			var preNode : RoleNode;
			var nextNode : RoleNode;

			if (length == 1)
			{
				head = null;
				tail = null;
				node.pre = null;
				node.next = null;
				_length--;
				return;
			}

			if (node == head)
			{
				preNode = null;
				nextNode = node.next;
				head = nextNode;
			}
			else if (node == tail)
			{
				preNode = node.pre;
				nextNode = null;
				tail = preNode;
			}
			else
			{
				preNode = node.pre;
				nextNode = node.next;
			}

			if (preNode != null) preNode.next = nextNode;
			if (nextNode != null) nextNode.pre = preNode;

			node.pre = null;
			node.next = null;
			_length--;
		}

		/** 获取节点根据索引 */
		private function getByIndex(index : int) : RoleNode
		{
			if (index >= length) return null;
			var i : int = 0;
			var node : RoleNode = head;
			while (node.next != null)
			{
				if ( i == index)
				{
					break;
				}

				i++;
				node = node.next;
			}
			return node;
		}

		/** 获取长度 */
		public function get length() : uint
		{
			return _length;
		}

		/** 清理 */
		public function clear() : void
		{
			head = null;
			tail = null;
			_length = 0;
		}

		/** 打印 */
		public function print() : void
		{
			trace(toString());
		}

		public function toString() : String
		{
			var str : String = "";
			if (head == null) return str;
			var i : int = 0;
			var node : RoleNode = head;
			str += i + "  " + node.toString() + "\n";
			while (node.next != null)
			{
				i++;
				node = node.next;
				str += i + "  " + node.toString() + "\n";
			}
			return str;
		}

		/** 排序添加 */
		public function sortAdd(node : RoleNode) : int
		{
			if (node == null) return 0;

			// 如果头为空
			if (head == null)
			{
				add(node);
				return 0;
			}

			// 如果自己小于或等于头
			if (node.compare(head) <= 0)
			{
				add(node, 0);
				return 0;
			}

			// 如果自己大于或等于尾
			if (node.compare(tail) >= 0)
			{
				add(node);
				return length - 1;
			}

			var index : int = 1;
			var compareNode : RoleNode = head;
			while (compareNode != null)
			{
				if (node.compare(compareNode) >= 0)
				{
					if (compareNode.next != null && node.compare(compareNode.next) <= 0)
					{
						add(node, index);
						break;
					}
					else if (compareNode.next == null)
					{
						add(node, index);
						break;
					}
				}
				index++;
				compareNode = compareNode.next;
			}
			return index;
		}

		/** 
		 * 更新排序
		 * @return 返回是否改变
		 */
		public function sortUpdate(node : RoleNode) : Boolean
		{
			var isChange : Boolean = false;
			var isMove : Boolean = false;
			if (node.pre && node.compare(node.pre) < 0)
			{
				while (node.pre && node.compare(node.pre) < 0)
				{
					isMove = preMoveOnce(node);
					if (isMove == true) isChange = true;
				}
			}
			else if (node.next && node.compare(node.next) > 0)
			{
				while (node.next && node.compare(node.next) > 0)
				{
					isMove = nextMoveOnce(node);
					if (isMove == true) isChange = true;
				}
			}
			return isChange;
		}

		/** 
		 * 上移一个节点
		 * @return 返回是否改变
		 */
		private function preMoveOnce(node : RoleNode) : Boolean
		{
			if (node == null) return false;
			var isChange : Boolean = false;
			var preNode : RoleNode;
			var nextNode : RoleNode;
			var preNode2 : RoleNode;
			preNode = node.pre;
			nextNode = node.next;

			if (preNode != null) preNode2 = preNode.pre;
			if (preNode != null)
			{
				if (preNode2 != null)
				{
					preNode2.next = node;
				}
				else if (head == preNode)
				{
					head = node;
				}
				node.pre = preNode2;
				node.next = preNode;
				preNode.pre = node;
				preNode.next = nextNode;
				if (nextNode != null)
				{
					nextNode.pre = preNode;
				}
				else if (tail == node)
				{
					tail = preNode;
				}

				isChange = true;
			}
			return isChange;
		}

		/** 
		 * 下移一个节点
		 * @return 返回是否改变
		 */
		private function nextMoveOnce(node : RoleNode) : Boolean
		{
			if (node == null) return false;
			var isChange : Boolean = false;
			var preNode : RoleNode;
			var nextNode : RoleNode;
			var nextNode2 : RoleNode;
			preNode = node.pre;
			nextNode = node.next;
			if (nextNode != null) nextNode2 = nextNode.next;
			if (nextNode != null)
			{
				if (preNode != null)
				{
					preNode.next = nextNode;
				}
				else if (head == node)
				{
					head = nextNode;
				}
				nextNode.pre = preNode;
				nextNode.next = node;
				node.pre = nextNode;
				node.next = nextNode2;
				if (nextNode2 != null)
				{
					nextNode2.pre = node;
				}
				else if (tail == nextNode)
				{
					tail = node;
				}
				isChange = true;
			}
			return isChange;
		}
	}
}
class Singleton
{
}