function main(...)
	local args = {...}
	local n = 0
	while args[n+1] do n=n+1 end --"count number of arguments"
	print("no. of arguments: "..n)
	if n<1 then print(help) return end
	
	help = [=[

eugenics.lua
---------
	A script that places a nickname on owned animals with a technical format based on their attributes.
 ex: "dogM 173 28N/50% 101cu   4/12y"
dogM -- dog male
173 -- creature number for dogs
28N -- maximum attainable physical attribute(strength in this example): 2800 divided by 100
/50%-- percentage of current attribute: 50%
101cu -- body size modifuer
  4/12y-- remaining years until a unit becomes old: 4 years (Formatted to 3 characters, the other 2 characters are spaces so it can be properly sorted on the animals interface. ex: 110 is greater than 2, but without the spaces, 2 is sorted as larger than 110.

Best used with dfhack's "sort-units name" script while on the animals interface(defaul "z" -> animals). Type and enter "sort-units" in the dfhack console for instructions.

Syntax:
rules: 
* menu arguments must be called alone

--menu arguments
	help -- shows this dialog
	refs -- list reference id of all creatures
	show -- show all nicknames of livestocks

--naming arguments
	race -- species name
	ids -- creature ref number
	size -- body size modifier
	age -- remaining years until old
	str -- strength
	tgh -- toughness
	agi -- agility
	end -- endurance
	rec -- recuperation
	imm -- immunity/disease resistance

--specifier arguments
	all - all creatures
	### - reference id


	]=]

--[[]]
	--[[FUNCTION CHECK FOR VALID UNITS]]
	local isciv = df.global.ui.civ_id
	function validunit(u)
	--[[]]	local tlevel = u.training_level
	--[[]]	if (u.civ_id == isciv 
	--[[]]	and not u.flags2.killed 
	--[[]]	and tlevel >= 0 and tlevel <= 7) then
	--[[]]		a = true
	--[[]]		return a
	--[[]]	end
	end

	local dfx = df.global.world.units.active
	ce = df.creature_raw
	local attr_args = {
	--[[]]	["age"] = true,
	--[[]]	["race"] = true,
	--[[]]	["ids"] = true,
	--[[]]	["size"] = true,
	--[[]]	["str"] = true,
	--[[]]	["tgh"] = true,
	--[[]]	["end"] = true,
	--[[]]	["agi"] = true,
	--[[]]	["rec"] = true,
	--[[]]	["imm"] = true,	}
	local spec_all = {
	--[[]]	["ALL"] = true	}
	local spec_num = {
	--[[]]	["num"] = true	}
	lone_args = {
	--[[]]	["help"] = 	function () print(help) end,
	--[[]]	["refs"] = 	function () --list reference numbers of creatures
	--[[]]				ce = df.creature_raw
	--[[]]				n = 0
	--[[]]				while n<=10000 do
	--[[]]					if (ce.find(n) == nil) then return end
	--[[]]					print(n, ce.find(n).creature_id)
	--[[]]					n = n+1
	--[[]]				end
	--[[]]			end,
	--[[]]	["show"] = 	function () 
	--[[]]				for _,v in ipairs(dfx) do
	--[[]]					if (v.name.nickname ~=0 and validunit(v)) then
	--[[]]						print(v.name.nickname)
	--[[]]					end
	--[[]]				end
	--[[]]			end,
	--[[]]	["rset"] =	function ()
	--[[]]				for _,v in ipairs(dfx) do
	--[[]]					if (v.name.nickname ~=0 and validunit(v)) then
	--[[]]						v.name.nickname = ""
	--[[]]						v.name.has_name = false
	--[[]]					end
	--[[]]				end
	--[[]]			end
	--[[]]	}

	--[[LONE_ARGS EXECUTION]]
	if (n==1) then
	--[[]]	if lone_args[args[1]] then
	--[[]]		lone_args[args[1]]()
	--[[]]		return
	--[[]]	else print("no no no") return
	--[[]]	end
	end

	--[[CHECKING FOR MULTIPLE VALID ARGUMENTS]]	
	local arg_cache = {}
	if n>1 then
	--[[]]	h = {} --"reference number table"
	--[[]]	ja = {} --"attribute arguments"
	--[[]]	for _,v in pairs(args) do
	--[[]]		local x = v
	--[[]]		xn = tonumber(x)
	--[[]]		if (attr_args[x]~=nil and not arg_cache[x]) then 
	--[[]]			table.insert(ja, x)
	--[[]]			arg_cache[x] = true
	--[[]]		elseif (xn and not h[xn] and xn>-1 and xn<1000) then
	--[[]]			spec_num["num"] = false
	--[[]]			if h[xn] == nil then
	--[[]]				h[xn] = true
	--[[]]			else return
	--[[]]			end
	--[[]]		elseif spec_all[x] then
	--[[]]			spec_all["ALL"] = false
	--[[]]		else print("duplicate or wrong argument: ".."\""..x.."\"") return
	--[[]]		end
	--[[]]	end
	end

	--[[CHECK IF NO SPECIFIER IS FOUND]]
	if (n>1 and spec_num["num"] and spec_all["ALL"]) then
	--[[]]	print("missing specifier")
	--[[]]	return	
	end

	--[[NICKNAMING FUNCTION]]
	local function nickname(u) --unit, valid attributes table
	--[[]]	local nname = ""
	--[[]]	local xi
	--[[]]	if u.sex == 0 then xi = "F"
	--[[]]	elseif u.flags3.gelded then xi = "X"
	--[[]]	else xi = "M"
	--[[]]	end
	--[[]]	local phys = u.body.physical_attrs
	--[[]]	local function phtr(aaa, sym)
	--[[]]		local aa = aaa
	--[[]]		local ab = math.floor(aa.max_value/100)
	--[[]]		local fst = math.floor(aa.value/ab)
	--[[]]		local cd = ab..sym.."/"..fst.."% "
	--[[]]		nname = nname..cd
	--[[]]		print(nname)
	--[[]]	end
	--[[]]
	--[[]]	local attr_func = {
	--[[]]		["age"] = 	function ()
	--[[]]					local o_year, b_year, c_year, age_l, rem
	--[[]]					o_year = u.old_year
	--[[]]						b_year = u.birth_year
	--[[]]					c_year = df.global.cur_year
	--[[]]					rem = string.format("%3d", (o_year - c_year))
	--[[]]					nname = nname..rem.."/"..(o_year - b_year).." "
	--[[]]				end,
	--[[]]		["race"] =	function ()
	--[[]]					local race_ = (ce.find(u.race).creature_id)
	--[[]]					race_ = string.gsub(race_, "BIRD_", "")
	--[[]]					race_ = string.gsub(race_, "GIANT_", "G")
	--[[]]					race_ = string.gsub(race_, " ","")
	--[[]]					race_ = string.sub(race_, 1, 5)
	--[[]]					race_ = race_:lower()..xi.." "
	--[[]]					nname = nname..race_
	--[[]]				end,
	--[[]]		["ids"] = 	function ()
	--[[]]					local race_id = (u.race)..xi.." "
	--[[]]					nname = nname..race_id	
	--[[]]				end,
	--[[]]		["size"] = 	function ()
	--[[]]					local bs_mod = u.appearance.size_modifier
	--[[]]					bs_mod = string.format("%3dcu ", bs_mod)
	--[[]]					nname = nname..bs_mod
	--[[]]				end,
	--[[]]		["str"] = function () phtr(phys.STRENGTH, "N") end,
	--[[]]		["tgh"] = function () phtr(phys.TOUGHNESS, "g") end,
	--[[]]		["end"] = function () phtr(phys.ENDURANCE, "J") end,
	--[[]]		["agi"] = function () phtr(phys.AGILITY, "z") end,
	--[[]]		["rec"] = function () phtr(phys.RECUPERATION, "W") end,
	--[[]]		["imm"] = function () phtr(phys.DISEASE_RESISTANCE, "y") end	}
	--[[]]		
	--[[]]		local n = 1
	--[[]]		for _,v in pairs(ja) do
	--[[]]			attr_func[v]()
	--[[]]		end
	--[[]]		print(nname)
	--[[]]		local nick = u.name
	--[[]]		nick.nickname = nname
	--[[]]		nick.has_name = true
	end

	--[[CHOOSING EXECUTION PATH]]	
	if (not spec_all["ALL"] and not spec_num["num"]) then
	--[[]]	for a,v in ipairs(dfx) do
	--[[]]		if (not h[v.race] and validunit(v)) then
	--[[]]			nickname(v)
	--[[]]		end
	--[[]]	end
	elseif not spec_all["ALL"] then
	--[[]]	for a,v in ipairs(dfx) do
	--[[]]		if (validunit(v)) then
	--[[]]			nickname(v)
	--[[]]		end
	--[[]]	end
	elseif not spec_num["num"] then
	--[[]]	for a,v in ipairs(dfx) do
	--[[]]		if (h[v.race] and validunit(v)) then
	--[[]]			nickname(v)
	--[[]]		end
	--[[]]	end
	end
	
	print("lualua.lua executed")
	



end



if not dfhack_flags.module then
    main(...)
end