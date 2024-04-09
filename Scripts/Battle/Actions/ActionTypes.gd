class_name ActionTypes

## The different types of targets that a stored action can be.
enum ActionTypes 
{
	SingleEnemy,
	AllEnemies, # Targets all the enemies of the activator
	SingleAlly,
	AllAllies,
	Defend,
	UseItem,
	Self,
	Flee
}
