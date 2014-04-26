package game.handler; 

import com.haxepunk.utils.Key;
import flaxen.core.Flaxen;
import flaxen.core.FlaxenHandler;
import flaxen.core.Log;
import flaxen.service.InputService;
import flaxen.component.*;

class PlayHandler extends FlaxenHandler
{
	public var f:Flaxen;

	public function new(f:Flaxen)
	{
		super();
		this.f = f;
	}

	override public function start(_)
	{
		f.newSingleton("wall")
			.add(new Layer(100))
			.add(Position.zero())
			.add(new Image("art/wall.png"))
			.add(Repeating.instance);
		f.newSingleton("floor")
			.add(new Layer(95))
			.add(new Position(0, 538))
			.add(new Image("art/floor.png"));

		var parent = new NestablePosition(100, 100);
		trace(" - parent:" + parent);
		var child = new NestablePosition(10, 10, parent);
		trace(" - parent:" + parent + " child:" + child); // 110,110
		child.set(5, 5);
		trace(" - parent:" + parent + " child:" + child); // 105,105
		parent.set(50, 50);
		trace(" - parent:" + parent + " child:" + child); // 55, 55
		child.x = 20;
		child.y = 40;
		trace(" - parent:" + parent + " child:" + child); // 70, 90
		trace("Child:" + child.x + "," + child.y);

	}

	override public function update(_)
	{
		var key = InputService.lastKey();
		//...
		InputService.clearLastKey();
	}
}
