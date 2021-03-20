# tagpets
Tested in DFhack 47.05-beta-1 

To use, download tagpets.lua and paste it to \*main\*/hack/scripts.  
\*main\* = Dwarf Fortress main folder w/ DFhack installed  

tagpets.lua  
---------
	A script that places a nickname on owned animals with a technical format based on their attributes. Best used with dfhack's "sort-units name" command while on the animals interface(defaul "z" -> animals). Type and enter "sort-units" in the dfhack console for instructions. Default keybinding for Dfhack 47.05 is "Shift+Alt+N"  
Notice: This script does not affect first_name and last_name  

ex: type --> tagpets 170 race ids str size age --> Enter  
 result: "dogM 170M 28N/50% 101cu   4/12y"  
	dogM -- dog, male (F for female)  
	170M -- creature number for dogs, male  
	28N -- maximum attainable physical attribute(strength in this example): 2800 divided by 100  
	/50%-- percentage of current attribute with respect to maximum: 50%  
	101cu -- body size modifuer  
	  4/12y-- remaining years until a unit becomes old: 4 years (Formatted to 3 characters, the other 2 characters are spaces so it can be properly sorted on the animals interface. For instance, between 4, 110, and 63, 110 is the largest, and 63 is the second, but if sorted without the spaces, the result becomes 63 -> 4 -> 110

Syntax:
petnames arg1 arg2 arg3 arg...  
ex: petnames 170 race str tgh age  

* all arguments must be separated by spaces.  
* arguments under the "menu" section must be called alone.  
* any number of arguments under the both "naming" and "specifier" section can be called together, as long as there's no duplicate.  
* "naming" arguments are processed based on order.  
* "specifier" arguments have combination effects.  
-- if ALL is the only specifier called, then all pets and livestockes will be affected.  
-- if numbers are the only specifiers, then pets and livestocks which has the same creature number will be affected.  
-- if ALL and any numbers are called, then all pets and livestocks except those with the creature numbers will be affected.  

args:  
--menu:  
	help -- shows this dialog  
	refs -- list reference id of all creatures  
	show -- show all nicknames of pets and livestocks  
	rset -- removes all nicknames of pets and livestocks(does not affect game-generated firstname or lastname)  

--naming:  
	race -- species name  
	ids -- creature ref number  
	size -- body size modifier  
	age -- remaining years until old  
	str -- strength,"St"  
	tgh -- toughness,"Tg"  
	agi -- agility,"Ag"  
	end -- endurance,"En"  
	rec -- recuperation,"Rc"  
	imm -- immunity/disease resistance,"Dr"  

--specifier:  
	ALL - all livestocks  
	### - creature number  
