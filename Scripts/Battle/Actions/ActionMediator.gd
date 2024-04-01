## Responsible for mediating between the actions, skill data, and the like.
class_name ActionMediator

## Stores the different types of damage that can be applied.
var damage_data: Dictionary = {}

## The status effects that need to be sent. A key value pair of:
## {status effect : success chance}.
var status_effects_to_apply: Dictionary = {}

## How much healing to apply.
var heal_amount: int = 0
