--p = os.clock()

local function ch(...)
 local a0 = {...}
 local n = 0
 while a0[n+1] do n=n+1 end
 if n==0 then print("type and enter \"tagpets help\" for instructions") return
 else main(a0) end
end

function main(o)
 local ax = o
 local n = 0
 while ax[n+1] do n=n+1 end --"count number of arguments"
 --print("no. of arguments: "..n)
 if n==0 then print("type and enter 'tagpets help' for instructions") return end
 
 help = [=[

tagpets.lua
---------
*NOTE this script only edits the nickname, not first_name or any other parts of the name.
*WARNING* When an animal becomes a pet of someone, the nickname will be taken as the pet's alternate name, 
	which cannot be changed. Be sure to remove all nicknames after using them.

	A script that places a nickname on owned animals with a technical format based on their attributes. 
	Best used with dfhack's "sort-units name" command while on the animals interface(defaul "z" -> animals). 
	Type and enter "sort-units" in the dfhack console for instructions, default keybinding for Dfhack 47.05 is "Shift+Alt+N"

Syntax:

tagpets arg1 arg2 arg3 [...]
ex: "tagpets 170 str tgh race"

rules: 
* all arguments must be separated by spaces.
* arguments under the "menu" section must be called alone.
* any number of arguments under the both "naming" and "specifier" section can be called together, as long as there's no duplicate.
* Only "naming" arguments are processed based on order.
* "specifier" arguments have combination effects.
-- if ALL is the only specifier called, then all pets and livestockes will be affected
-- if numbers are the only specifiers, then pets and livestocks which has the same creature number will be affected.
-- if ALL and any numbers are called, then all pets and livestocks except those with the creature numbers will be affected.

args: 
--menu:
	help -- shows this dialog
	refs -- list reference id of all creatures
	show -- show all nicknames of pets and livestocks
	rset -- removes all nicknames of pets and livestocks(also affects user-generated nicknames)

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


	]=]


  --[[FUNCTION CHECK FOR VALID UNITS]]
  local isciv = df.global.ui.civ_id
  local function validunit(u)
    local tlevel = u.training_level
    local ki = u.flags2.killed
    if (u.civ_id == isciv 
    and not ki
    and tlevel >= 0 and tlevel <= 7) then
      a = true
      return a
    end
  end

  local dfx = df.global.world.units.active
  local ce = df.creature_raw
  local a_args = {
    ["age"] = true,
    ["race"] = true,
    ["ids"] = true,
    ["size"] = true,
    ["str"] = true,
    ["tgh"] = true,
    ["end"] = true,
    ["agi"] = true,
    ["rec"] = true,
    ["imm"] = true,  }
  local s_all = {
    ["ALL"] = true  }
  local s_num = {
    ["num"] = true  }
  local l_args = {
    ["help"] =   function () print(help) end,
    ["refs"] =   function () --list reference numbers of creatures
          ce = df.creature_raw
          n = 0
          while n<=10000 do
            if (ce.find(n) == nil) then return end
            print(n, ce.find(n).creature_id)
            n = n+1
          end
        end,
    ["show"] =   function () 
          for _,v in ipairs(dfx) do
            if (v.name.nickname ~=0 and validunit(v)) then
              print(v.name.nickname)
            end
          end
        end,
    ["rset"] =  function ()
          for _,v in ipairs(dfx) do
            if (v.name.nickname ~=0 and validunit(v)) then
              v.name.nickname = ""
              if v.name.first_name == "" then
                v.name.has_name = false
              end
            end
          end
        end
    }

  --[[l_args EXECUTION]]
  if (n==1) then
    if l_args[ax[1]] then
      l_args[ax[1]]()
      return
    else print("wrong syntax") return
    end
  end

  --[[CHECKING FOR MULTIPLE VALID ARGUMENTS]]  
  local arg_cache = {}
  if n>1 then
    h = {} --"reference number table"
    ja = {} --"attribute arguments"
    for _,v in pairs(ax) do
      local x = v
      xn = tonumber(x)
      if (a_args[x]~=nil and not arg_cache[x]) then 
        table.insert(ja, x)
        arg_cache[x] = true
      elseif (xn and not h[xn] and xn>-1 and xn<1000) then
        s_num["num"] = false
        if h[xn] == nil then
          h[xn] = true
        else return
        end
      elseif s_all[x] then
        s_all["ALL"] = false
      else print("wrong syntax: ".."\""..x.."\"") return
      end
    end
  end

  --[[CHECK IF NO SPECIFIER IS FOUND]]
  if (n>1 and s_num["num"] and s_all["ALL"]) then
    print("missing specifier")
    return  
  end

  --[[NICKNAMING FUNCTION]]
  local function nickname(u) --unit, valid attributes table
    local nname = ""
    local xi
    if u.sex == 0 then xi = "F"
    elseif u.flags3.gelded then xi = "X"
    else xi = "M"
    end
    local phys = u.body.physical_attrs
    local function phtr(c, sym)
      local aa = c
      local ab = math.floor(aa.max_value/100)
      local fst = math.floor(aa.value/ab)
      local cd = ab..sym.."/"..fst.."% "
      nname = nname..cd
    end
  
    local a_args = {
      ["age"] =   function ()
            local o_year, b_year, c_year, age_l, rem
            o_year = u.old_year
              b_year = u.birth_year
            c_year = df.global.cur_year
            rem = string.format("%3d", (o_year - c_year))
            nname = nname..rem.."/"..(o_year - b_year).."y "
          end,
      ["race"] =  function ()
            local race_ = (ce.find(u.race).creature_id)
            race_ = string.gsub(race_, "BIRD_", "")
            race_ = string.gsub(race_, "GIANT_", "G")
            race_ = string.gsub(race_, " ","")
            race_ = string.sub(race_, 1, 5)
            race_ = race_:lower()..xi.." "
            nname = nname..race_
          end,
      ["ids"] =   function ()
            local race_id = (u.race)..xi.." "
            nname = nname..race_id  
          end,
      ["size"] =   function ()
            local bs_mod = u.appearance.size_modifier
            bs_mod = string.format("%3dcu ", bs_mod)
            nname = nname..bs_mod
          end,
      ["str"] = function () phtr(phys.STRENGTH, "St") end,
      ["tgh"] = function () phtr(phys.TOUGHNESS, "Tg") end,
      ["end"] = function () phtr(phys.ENDURANCE, "En") end,
      ["agi"] = function () phtr(phys.AGILITY, "Ag") end,
      ["rec"] = function () phtr(phys.RECUPERATION, "Rc") end,
      ["imm"] = function () phtr(phys.DISEASE_RESISTANCE, "Dr") end  }
      
      local n = 1
      for _,v in pairs(ja) do
        a_args[v]()
      end
      --print(nname)
      local nick = u.name
      nick.nickname = nname
      nick.has_name = true
  end

  --[[CHOOSING EXECUTION PATH]]  
  if (not s_all["ALL"] and not s_num["num"]) then
    for _,v in ipairs(dfx) do
      if (not h[v.race] and validunit(v)) then
        nickname(v)
      end
    end
  elseif not s_all["ALL"] then
    for _,v in ipairs(dfx) do
      if (validunit(v)) then
        nickname(v)
      end
    end
  elseif not s_num["num"] then
    for _,v in ipairs(dfx) do
      if (h[v.race] and validunit(v)) then
        nickname(v)
      end
    end
  end
  
  print("tagpets.lua executed")

--print(os.clock() - p)
end

if not dfhack_flags.module then
    ch(...)
end
