package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.debug.watch.Tracker;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends BasicState
{
	// for reviving player
	var lastEntryID:Int;
	var lastTarget:String;	
	
	public var player : Player;
	
	public var ingredients : AdministratedList<IngredientDraggable>;
	public var burgerSlots : AdministratedList<BurgerSlot>;

	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		trace("playstate create begin");
		
		player = new Player();
		ingredients = new AdministratedList<IngredientDraggable>();
		
		var i : IngredientDraggable = new IngredientDraggable(300, 300, this, IngredientType.SALAD);
		ingredients.add(i);
		add(ingredients);
		

		burgerSlots = new AdministratedList<BurgerSlot>();
		var bs : BurgerSlot = new BurgerSlot(300, 500, this);
		burgerSlots.add(bs);
		add(burgerSlots);
		

		var testIngredient = new PlacedIngredient(IngredientType.BUN);
		var testIngredientsList = new Array<IngredientType>();
		testIngredientsList.push(IngredientType.BUN);
		var testRecipe = new Recipe(testIngredientsList);

	}

	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	
	override public function drawObjects():Void 
	{
		super.drawObjects();
		player.draw();
		
	}
	
	override public function drawOverlay():Void 
	{
		
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed : Float):Void
	{
		super.update(elapsed);
		MyInput.update();
		player.update(elapsed);
		//trace(ingredients.getList().members[0].active);
		//ingredients.update(elapsed);
		trace(ingredients.length());
		//burgerSlots.update(elapsed);
	}	

}
