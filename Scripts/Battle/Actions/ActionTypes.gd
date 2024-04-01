class_name ActionTypes

## The different types of targets that a stored action can be.
enum ActionTypes 
{
	SingleEnemy,
	Self,
	AllEnemies, # Targets all the enemies of the activator
	HealSingleAlly,
	HealAllAllies,
	Defend,
	UseItem,
	Flee
}
