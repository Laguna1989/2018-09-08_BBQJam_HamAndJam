package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */

enum BurgerStatus {
	ERROR; // returned e.g. when the burger is not actually finished yet
	FINISHED_IN_ORDER; // finished with the ingredients in the right order
	FINISHED_WRONG_ORDER; // finished with the ingredients in the wrong order
	FAILED_TOO_FEW; // finished with too few ingredients
	FAILED_WRONG_INGREDIENT; // finished with wrong ingredients
}

class Recipe extends FlxSprite 
{
	public var ingredients : Array<IngredientType> = new Array<IngredientType>();
	// the time when the player officially starts working on the recipe; before, it is null
	
	private var recipeGraphics : FlxSpriteGroup;
	
	public var recipeStarted : Bool = false;
	// the time the player has to complete the recipe in seconds
	public var recipeTime : Float;
	// the time that has elapsed in the game since the recipe was begun
	private var elapsedTime : Float = 0;
	public var points : Int;

	public function new(IngredientArray:Array<IngredientType>, ?rewardPoints:Int=1, ?maxRecipeTime:Float=30.0, ?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		ingredients = IngredientArray;
		points = rewardPoints;
		recipeTime = maxRecipeTime;
		this.makeGraphic(100, 100, FlxColor.MAGENTA);
		
		recipeGraphics = new FlxSpriteGroup();
		
	}
	
	function loadMyGraphics() 
	{
		trace(ingredients.length);
		var counter : Int = 0;
		
		for ( it in ingredients)
		{
			trace(it);
			if (it == IngredientType.SAUCE)
			{
				var i : PlacedIngredient = new PlacedIngredient(it, x, y );
				i.offset.set( - this.width, -( this.height -82));
				recipeGraphics.add(i);
			}
			else if (it == IngredientType.BUN_TOP)
			{
				counter += 1;
				var i : PlacedIngredient = new PlacedIngredient(it, x, y );
				i.offset.set(0, -( this.height - (counter * BurgerSlot.IngredientOffset) -8));
				recipeGraphics.add(i);
			}
			else
			{
				counter += 1;
				var i : PlacedIngredient = new PlacedIngredient(it, x, y );
				i.offset.set(0, -( this.height - counter * BurgerSlot.IngredientOffset ));
				recipeGraphics.add(i);
			}
			trace(recipeGraphics.members[0].x + " " + recipeGraphics.members[0].y);
		}
	}

	public function startRecipe(posX:Int, posY:Int)
	{
		recipeStarted = true;
		this.setPosition(posX, posY);
		loadMyGraphics();
	}

	override public function update(elapsed:Float)
	{
		if (recipeStarted)
		{
			elapsedTime+=elapsed;
		}
		recipeGraphics.update(elapsed);
	}

	/*
	 * returns the seconds remaining until the recipe time is over
	 */
	public function remainingTime()
	{
		if (recipeStarted)
		{
			return recipeTime - elapsedTime;
		}
		else
		{
			return recipeTime;
		}
	}

	public function getRequiredIngredients()
	{
		return ingredients.copy();
	}

	/*
	 * This function will return the BurgerStatus and should only be used when the top bun is on the burger
	 */
	public function getIngredientsFinished(proposedIngredients:Array<PlacedIngredient>)
	{
		if (proposedIngredients[-1].getID() != IngredientType.BUN_TOP)
		{
			trace("checking unfinished burger!");
			return BurgerStatus.ERROR;
		}
		// assume the best
		var currentState = BurgerStatus.FINISHED_IN_ORDER;
		// get ingredient IDs from proposedIngredients array
		var proposedIngredientIDs:Array<IngredientType> = new Array<IngredientType>();
		for (elem in proposedIngredients)
		{
			proposedIngredientIDs.push(elem.getID());
		}
		// next, check if the bottom patty has been added
		if (proposedIngredientIDs[0] != IngredientType.BUN_BOT)
		{
			return BurgerStatus.FAILED_WRONG_INGREDIENT;
		}
		// next, check for ingredients (first generally, then if they are in order)
		for (i in 1...proposedIngredientIDs.length)
		{
			if (i == ingredients.length)
			{
				// content part finished
				if (ingredients.length == proposedIngredientIDs.length)
				{
					// burger size is OK, go to final status
					break;
				}
				else
				{
					//burger too small => ingredients missing
					return BurgerStatus.FAILED_TOO_FEW;
				}
			}
			if (ingredients.indexOf(proposedIngredientIDs[i]) != -1)
			{
				// check if ingredient is in the wrong place
				if (proposedIngredientIDs[i] != ingredients[i])
				{
					// ingredient in the wrong place
					// check if already failed anyway, which would be worse
					if (currentState != BurgerStatus.FAILED_WRONG_INGREDIENT)
					{
						currentState = BurgerStatus.FINISHED_WRONG_ORDER;
					}
				}
			}
			else
			{
				currentState = BurgerStatus.FAILED_WRONG_INGREDIENT;
			}
		}
		return currentState;
	}
	
	override public function draw():Void 
	{
		super.draw();
		recipeGraphics.draw();
	}
}
