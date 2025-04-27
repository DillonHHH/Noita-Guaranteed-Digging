-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 3
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")
dofile("data/scripts/items/generate_shop_item.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile("data/scripts/biomes/temple_shared.lua")
dofile("data/scripts/perks/perk.lua")
dofile_once("data/scripts/biomes/temple_altar_top_shared.lua")

RegisterSpawnFunction(0xffffeedd, "init")
RegisterSpawnFunction(0xff6d934c, "spawn_hp")
RegisterSpawnFunction(0xff33934c, "spawn_all_shopitems")
-- RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )
-- RegisterSpawnFunction( 0xff33935F, "spawn_cheap_shopitem" )
RegisterSpawnFunction(0xff10822d, "spawn_workshop")
RegisterSpawnFunction(0xff5a822d, "spawn_workshop_extra")
RegisterSpawnFunction(0xffFAABBA, "spawn_motordoor")
RegisterSpawnFunction(0xffFAABBB, "spawn_pressureplate")
RegisterSpawnFunction(0xff03DEAD, "spawn_areachecks")
RegisterSpawnFunction(0xff03deaf, "spawn_fish")
RegisterSpawnFunction(0xff784dd2, "spawn_worm_deflector")
RegisterSpawnFunction(0xff7345DF, "spawn_perk_reroll")
RegisterSpawnFunction(0xff420A3D, "spawn_trigger_check_stats")
RegisterSpawnFunction(0xff420a3f, "spawn_trigger_check_stats_reference")
RegisterSpawnFunction(0xffc128ff, "spawn_rubble")
RegisterSpawnFunction(0xffa7a707, "spawn_lamp_long")
RegisterSpawnFunction(0xff03fade, "spawn_spell_visualizer")


g_lamp =
{
	total_prob = 0,
	{
		prob      = 1.0,
		min_count = 1,
		max_count = 1,
		entity    = ""
	},
	{
		prob      = 1.0,
		min_count = 1,
		max_count = 1,
		entity    = "data/entities/props/physics/temple_lantern.xml"
	},
}

g_fish =
{
	total_prob = 0,
	{
		prob      = 5.0,
		min_count = 1,
		max_count = 1,
		entity    = ""
	},
	{
		prob      = 1.0,
		min_count = 2,
		max_count = 5,
		entity    = "data/entities/animals/fish.xml"
	},
}

g_rubble =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob      = 2.0,
		min_count = 1,
		max_count = 1,
		entity    = ""
	},
	{
		prob      = 0.1,
		min_count = 1,
		max_count = 1,
		entity    = "data/entities/props/physics_temple_rubble_01.xml"
	},
	{
		prob      = 0.1,
		min_count = 1,
		max_count = 1,
		entity    = "data/entities/props/physics_temple_rubble_02.xml"
	},
	{
		prob      = 0.1,
		min_count = 1,
		max_count = 1,
		entity    = "data/entities/props/physics_temple_rubble_03.xml"
	},
	{
		prob      = 0.1,
		min_count = 1,
		max_count = 1,
		entity    = "data/entities/props/physics_temple_rubble_04.xml"
	},
	{
		prob      = 0.1,
		min_count = 1,
		max_count = 1,
		entity    = "data/entities/props/physics_temple_rubble_05.xml"
	},
	{
		prob      = 0.1,
		min_count = 1,
		max_count = 1,
		entity    = "data/entities/props/physics_temple_rubble_06.xml"
	},
}

function spawn_small_enemies(x, y) end

function spawn_big_enemies(x, y) end

function spawn_items(x, y) end

function spawn_props(x, y) end

function spawn_props2(x, y) end

function spawn_props3(x, y) end

function load_pixel_scene(x, y) end

function load_pixel_scene2(x, y) end

function spawn_unique_enemy(x, y) end

function spawn_unique_enemy2(x, y) end

function spawn_unique_enemy3(x, y) end

function spawn_ghostlamp(x, y) end

function spawn_candles(x, y) end

function spawn_potions(x, y) end

function init(x, y, w, h)
	spawn_altar_top(x, y, false)
	LoadPixelScene("data/biome_impl/temple/altar.png", "data/biome_impl/temple/altar_visual.png", x, y - 40 + 300,
		"data/biome_impl/temple/altar_background.png", true)
end

function spawn_hp(x, y)
	EntityLoad("data/entities/items/pickup/heart_fullhp_temple.xml", x - 16, y)
	EntityLoad("data/entities/buildings/music_trigger_temple.xml", x - 16, y)
	EntityLoad("data/entities/items/pickup/spell_refresh.xml", x + 16, y)
	EntityLoad("data/entities/buildings/coop_respawn.xml", x, y)
end

function spawn_shopitem(x, y)
	-- EntityLoad( "data/entities/items/shop_item.xml", x, y )
	-- generate_shop_item( x, y, false )
end

function spawn_cheap_shopitem(x, y)
	-- EntityLoad( "data/entities/items/shop_item.xml", x, y )
	-- generate_shop_item( x, y, true )
end

function spawn_all_shopitems(x, y)
	local spawn_shop, spawn_perks = temple_random(x, y)
	if (spawn_shop == "0") then
		return
	end

	local first_temple = math.ceil(y / 512) == 3
	local extra_items = { "BLACK_HOLE", "LUMINOUS_DRILL", "BLACK_HOLE", "LUMINOUS_DRILL" }
	local prices = { 300, 300, 300, 250 }


	-- extra_items and prices MUST have the same length
	if (#extra_items ~= #prices) then
		return
	end


	EntityLoad("data/entities/buildings/shop_hitbox.xml", x, y)

	SetRandomSeed(x, y)
	local count
	if first_temple then
		count = tonumber(GlobalsGetValue("TEMPLE_SHOP_ITEM_COUNT", "5")) + (math.ceil(#extra_items / 2) + 1)
	else
		count = tonumber(GlobalsGetValue("TEMPLE_SHOP_ITEM_COUNT", "5"))
	end
	local width = 132
	local item_width = width / count
	local sale_item_i = Random(1, count)
	local extra_items_index
	if first_temple then
		extra_items_index = count - (#extra_items - 1)
	else
		extra_items_index = count
	end

	if (Random(0, 100) <= 50) then
		for i = 1, extra_items_index do
			if (i == sale_item_i) then
				generate_shop_item(x + (i - 1) * item_width, y, true, nil, true)
			else
				generate_shop_item(x + (i - 1) * item_width, y, false, nil, true)
			end

			generate_shop_item(x + (i - 1) * item_width, y - 30, false, nil, true)
			LoadPixelScene("data/biome_impl/temple/shop_second_row.png",
				"data/biome_impl/temple/shop_second_row_visual.png", x + (i - 1) * item_width - 8, y - 22, "", true)
		end
	else
		for i = 1, extra_items_index do
			if (i == sale_item_i) then
				generate_shop_wand(x + (i - 1) * item_width, y, true)
			else
				generate_shop_wand(x + (i - 1) * item_width, y, false)
			end
		end
	end

	if first_temple then
		for i = 1, math.ceil(#extra_items / 2) do
			add_item(extra_items[(2 * i) - 1], x + ((i + extra_items_index) - 1) * item_width, y, prices[(2 * i) - 1],
				false)
			if 2 * i <= #extra_items then
				add_item(extra_items[2 * i], x + ((i + extra_items_index) - 1) * item_width, y, prices[2 * i], true)
			end
		end
	end
end

function add_item(item, x, y, price, second_row)
	local eid
	if second_row then
		eid = CreateItemActionEntity(item, x, y - 30)
	else
		eid = CreateItemActionEntity(item, x, y)
	end
	local price_text = tostring(price)

	local textwidth = 0

	for i = 1, #price_text do
		local l = string.sub(price_text, i, i)

		if (l ~= "1") then
			textwidth = textwidth + 6
		else
			textwidth = textwidth + 3
		end
	end

	local offsetx = textwidth * 0.5 - 0.5

	if second_row then
		LoadPixelScene("data/biome_impl/temple/shop_second_row.png",
			"data/biome_impl/temple/shop_second_row_visual.png", x - 8,
			y - 22, "", true)
	end
	EntityAddComponent(eid, "SpriteComponent", {
		_tags = "shop_cost,enabled_in_world",
		image_file = "data/fonts/font_pixel_white.xml",
		is_text_sprite = "1",
		offset_x = offsetx,
		offset_y = "25",
		update_transform = "1",
		update_transform_rotation = "0",
		text = price_text,
		z_index = "-1",
	})
	EntityAddComponent(eid, "ItemCostComponent", {
		_tags = "shop_cost,enabled_in_world",
		cost = price,
		stealable = true
	})

	EntityAddComponent(eid, "LuaComponent", {
		script_item_picked_up = "data/scripts/items/shop_effect.lua",
	})
end

function spawn_workshop(x, y)
	EntityLoad("data/entities/buildings/workshop.xml", x, y)
end

function spawn_workshop_extra(x, y)
	EntityLoad("data/entities/buildings/workshop_allow_mods.xml", x, y)
end

function spawn_motordoor(x, y)
	EntityLoad("data/entities/props/physics_templedoor2.xml", x, y)
end

function spawn_pressureplate(x, y)
	EntityLoad("data/entities/props/temple_pressure_plate.xml", x, y)
end

function spawn_lamp(x, y)
	spawn(g_lamp, x, y, 0, 10)
end

function spawn_lamp_long(x, y)
	spawn(g_lamp, x, y, 0, 15)
end

function spawn_areachecks(x, y)
	if (temple_should_we_spawn_checkers(x, y)) then
		EntityLoad("data/entities/buildings/temple_areacheck_horizontal.xml", x + 180, y - 65 - 16 - 20)
		EntityLoad("data/entities/buildings/temple_areacheck_horizontal.xml", x + 180, y + 140)
	end
end

function spawn_worm_deflector(x, y)
	-- EntityLoad( "data/entities/buildings/physics_worm_deflector.xml", x, y )
	EntityLoad("data/entities/buildings/physics_worm_deflector_crystal.xml", x, y + 5)
	EntityLoad("data/entities/buildings/physics_worm_deflector_base.xml", x, y + 5)
end

function spawn_all_perks(x, y)
	SetRandomSeed(x, y)

	if (GlobalsGetValue("TEMPLE_SPAWN_GUARDIAN") == "1") then
		-- EntityLoad( "data/entities/misc/spawn_necromancer_shop.xml", x + 30, y - 30 )
		temple_spawn_guardian(x + 30, y - 30)
	else
		EntityLoad("data/entities/buildings/workshop_guardian_spawn_pos.xml", x + 30, y - 30)
	end

	local spawn_shop, do_spawn_perks = temple_random(x, y)
	if (do_spawn_perks == "0") then
		return
	end

	perk_spawn_many(x, y)
end

function spawn_perk_reroll(x, y)
	EntityLoad("data/entities/items/pickup/perk_reroll.xml", x, y)
end

function spawn_trigger_check_stats(x, y)
	EntityLoad("data/entities/buildings/workshop_trigger_check_stats.xml", x, y)
end

function spawn_trigger_check_stats_reference(x, y)
	EntityLoad("data/entities/buildings/workshop_trigger_check_stats_reference.xml", x, y)
end

function spawn_fish(x, y)
	local f = GameGetOrbCountAllTime()

	for i = 1, f do
		EntityLoad("data/entities/animals/fish.xml", x, y)
	end
end

function spawn_rubble(x, y)
	spawn(g_rubble, x, y, 5, 0)
end

function spawn_spell_visualizer(x, y)
	EntityLoad("data/entities/buildings/workshop_spell_visualizer.xml", x, y)
	EntityLoad("data/entities/buildings/workshop_aabb.xml", x, y)
end
