extends Node2D

onready var i = -1
onready var pain
onready var no_pain
onready var i_image
onready var folder
onready var image
onready var label = 0
onready var score = 0 
onready var data = {}
onready var sheep = get_node('sheep').get_node('sprite')
onready var hour_min_sec 
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
		
	label = i
	i_image = randi() % len(folder)
	image = folder[i_image]
	sheep.set_texture(load('res://Images/' + str(i) + '/' + image))
	
	
func _ready():
	pain = list_files_in_directory('res://Images/1')
	no_pain = list_files_in_directory('res://Images/0')
	change_image()

func _on_happy_pressed():
	if label == 0:
		score += 1 
	var t = OS.get_datetime()
	var day_month = str(t.day) + '/' + str(t.month) 
	hour_min_sec = str(t.hour) + '_' + str(t.minute) + '_' + str(t.second)
	data[hour_min_sec] = [day_month, hour_min_sec, image, 0, label]
	change_image()


func _on_sad_pressed():
	if label == 1:
		score += 1 
	var t = OS.get_datetime()
	var day_month = str(t.day) + '/' + str(t.month) 
	hour_min_sec = str(t.hour) + '_' + str(t.minute) + '_' + str(t.second)
	data[hour_min_sec] = [day_month, hour_min_sec, image, 0, label]
	change_image()



func _on_Button_pressed():
	var file = File.new()
	file.open('res://Data/data_' + hour_min_sec + '.csv', file.WRITE)
	file.store_csv_line(['day/month', 'time', 'image name', 'given score', 'ground truth'], ',')
	for i in data:
		var line = data[i]
		file.store_csv_line(line, ',')
	file.close()
