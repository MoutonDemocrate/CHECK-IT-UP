extends Resource
class_name ScoreBoard

@export var scores : Array[Score]

func add_score(new_score : Score) -> void :
	print("Adding score...")
	if scores.is_empty() :
		scores.append(new_score)
		print("Scoreboard empty, adding first score...")
	else:
		for i in range(0, scores.size()):
			if new_score.score >= scores[i].score:
				scores.insert(i, new_score)
				return
		scores.append(new_score)
