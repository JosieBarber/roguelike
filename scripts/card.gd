#Card.gd

extends Node2D

class_name card

var card_name: String
var card_effect: String
var card_clause: String
var card_type: String
var card_sprite: String
var card_damage: int

func _init(card_name_param: String, effect: String, clause: String, type: String, sprite: String, damage: int):
    card_name = card_name_param
    card_effect = effect
    card_clause = clause
    card_type = type
    card_sprite = sprite
    card_damage = damage

func _ready():
    # Initialize the card when it is added to the scene
    pass
