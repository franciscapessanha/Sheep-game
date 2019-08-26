extends Node2D

onready var i = -1
onready var pain
onready var no_pain
onready var i_image
onready var folder
onready var image

onready var sheep = get_node('sheep').get_node('sprite')

func list_files_in_directory(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == '':
            break
        elif not file.begins_with('.') and file.ends_with('.png'):
            files.append(file)

    dir.list_dir_end()
    return files
func change_image():
	i = randi() % 2
	if i == 0:
		folder = no_pain
	else:
		folder = pain
		
	i_image = randi() % len(folder)
	image = folder[i_image]
	sheep.set_texture(load('res://Images/' + str(i) + '/' + image))
	
	
func _ready():
	pain = list_files_in_directory('res://Images/1')
	no_pain = list_files_in_directory('res://Images/0')
	change_image()

func _on_happy_pressed():
	change_image()


func _on_sad_pressed():
	change_image()

