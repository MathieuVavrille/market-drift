extends Node2D

func set_nb_medals(nb_medals: int):
	var total = $Objects.get_child_count()
	$Crown.visible = nb_medals == 80
	var nb_to_show = int(nb_medals ** 0.75 / 80 ** 0.75 * total)
	var children = $Objects.get_children()
	for i in range(total):
		children[i].visible = i < nb_to_show
