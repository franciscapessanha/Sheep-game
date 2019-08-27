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
onready var day
onready var TOTAL_SHEEP = 10
onready var n = 1

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
	var i_s = load('res://Images/' + str(i) + '/' + image).get_size() #image size
	var th = 150 #target height
	var tw = 150 #target width
	var scale = Vector2((i_s.x/(i_s.x/tw)/100), (i_s.y/(i_s.y/th)/100))
	sheep.set_scale(scale)
	
func save():
	var file = File.new()
	file.open('res://Data/data_' + day + '_' + hour_min_sec + '.csv', file.WRITE)
	file.store_csv_line(['day/month', 'time', 'image name', 'given score', 'ground truth'], ',')
	for i in data:
		var line = data[i]
		file.store_csv_line(line, ',')
	file.close()
		
func _ready():
	pain = list_files_in_directory('res://Images/1')
	no_pain = list_files_in_directory('res://Images/0')
	change_image()

func end():
	get_node('happy').queue_free()
	get_node('sad').queue_free()
	get_node('sheep').queue_free()
	var a = preload("res://Scenes/final_menu.tscn").instance()
	add_child(a)
	a.get_node('score').set_text('Score : ' + str(score) + ' / 10') 
	
	
func _on_happy_pressed():
	if label == 0:
		score += 1 
	var t = OS.get_datetime()
	day = str(t.day)
	var day_month = str(t.day) + '/' + str(t.month) 
	hour_min_sec = str(t.hour) + '_' + str(t.minute) + '_' + str(t.second)
	data[hour_min_sec] = [day_month, hour_min_sec, image, 0, label]
	if n < TOTAL_SHEEP:
		change_image()
		n += 1
	else:
		save()
		end()


func _on_sad_pressed():
	if label == 1:
		score += 1 
	var t = OS.get_datetime()
	day = str(t.day)
	var day_month = str(t.day) + '/' + str(t.month) 
	hour_min_sec = str(t.hour) + '_' + str(t.minute) + '_' + str(t.second)
	data[hour_min_sec] = [day_month, hour_min_sec, image, 0, label]
	
	if n < TOTAL_SHEEP:
		change_image()
		n += 1
	else:
		save()
		end()
	