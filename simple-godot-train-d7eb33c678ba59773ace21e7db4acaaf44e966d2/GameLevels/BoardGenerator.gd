extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tiles = []

var farm1 = preload("res://GameTiles/Farm.tscn")
var town1 = preload("res://GameTiles/Small Town.tscn")
var quarry1 = preload("res://GameTiles/Quarry.tscn")

# Called when the node enters the scene tree for the first time.
var tilesPerRow = 1

func _ready():
	tiles.append(farm1)
	tiles.append(town1)
	tiles.append(quarry1)
	GenerateBoard()


func GenerateBoard():
	tiles.shuffle()
	var x = 0
	var y = 0
	for tile in tiles:
		print(x)
		var z = tile.instance()
		if tile == town1:
			add_child(z, true)
			z.name = "Small Town"
		else:
			add_child(z)
		z.global_position = (Vector2(x*32*175/2,y*32*175/2))
		print(z.global_position)
		if x < tilesPerRow:
			x +=1
		else:
			x = 0
			y += 1

