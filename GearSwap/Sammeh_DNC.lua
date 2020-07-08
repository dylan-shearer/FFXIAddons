
function get_sets()
    mote_include_version = 2
    include('Mote-Include.lua')
	include('sammeh_custom_functions.lua')
end

function user_setup()
	state.EngagedMode = M{['description']='Engaged Mode', 'Normal','ACC'}
	send_command('bind f9 gs c cycle EngageddMode')
    select_default_macro_book()
	
	-- Set Common Aliases --
	send_command("alias wsset gs equip sets.ws")
	send_command("alias eng gs equip sets.engaged")
	send_command("alias idle gs equip sets.Idle.Current")
	send_command('@wait 1;input /lockstyleset 3')
	
end

	
function init_gear_sets()
    -- Setting up Gear As Variables --

	-- Idle Sets
	
	sets.engaged = {
		ammo="Charis Feather",
	   	head="Espial Cap", 
		body="Mummu Jacket",
    		hands="Mummu Wrists",
    		legs="Mummu Kecks",
    		feet="Mummu Gamashes",
    		neck="Charis Necklace",
   		 waist="Windbuffet Belt +1",
    		left_ear="Suppanomimi",
    		right_ear="Brutal Earring",
    		left_ring="Epona's Ring",
		right_ring="Chirich Ring",
		back="Atheling Mantle",
	}
	sets.ws = {
		ammo="Charis Feather",
    head={ name="Lustratio Cap +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    body="Mummu Jacket",
    hands={ name="Lustr. Mittens +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    legs={ name="Lustr. Subligar +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    feet={ name="Lustra. Leggings +1", augments={'Accuracy+20','DEX+8','Crit. hit rate+3%',}},
    neck="Charis Necklace",
    waist="Windbuffet Belt +1",
    left_ear="Suppanomimi",
    right_ear="Brutal Earring",
    left_ring="Ilabrat Ring",
    right_ring="Begrudging Ring",
    back="Atheling Mantle",
	}
	
	
    ---  PRECAST SETS  ---
	sets.precast = {}
    sets.precast.JA = {}
	--sets.precast.JA.Meditate = {back="Smertrios's Mantle",hands={ name="Sakonji Kote", augments={'Enhances "Blade Bash" effect',}},head="Wakido Kabuto +1"}
    
	
	-- WS Sets
	sets.precast.WS = sets.ws
	
    ---  MIDCAST SETS  ---
    sets.midcast = {}
    
    ---  AFTERCAST SETS  ---
    sets.Idle = set_combine(sets.engaged,{feet="Skadi's Jambeaux +1"})
	sets.Idle.Current = sets.Idle
    sets.Resting = sets.Idle
	
	sets.WakeSleep = {head="Frenzy Sallet"}

end





function job_precast(spell)
    handle_equipping_gear(player.status)
	if spell.name == 'Utsusemi: Ichi' and (buffactive['Copy Image (3)'] or buffactive ['Copy Image (4+)']) then
	  cancel_spell()
	  send_command('@wait 1;gs c update')
	  return
	end
    if sets.precast.JA[spell.name] then
        equip(sets.precast.JA[spell.name])
    elseif string.find(spell.name,'Cur') and spell.name ~= 'Cursna' then
        equip(sets.precast.Cure)
    elseif spell.skill == 'EnhancingMagic' then
        equip(sets.precast.EnhancingMagic)
    elseif spell.action_type == 'Magic' then
        equip(sets.precast.FastCast)
    end
end

function job_post_midcast(spell)
    if spell.name == 'Utsusemi: Ichi' then
	  send_command('cancel Copy Image|Copy Image (2)')
	end
	if spell.type == "WeaponSkill" then
	  tpspent = spell.tp_cost
	end

end        

function job_aftercast(spell)
	if state.SpellDebug.value == "On" then 
      spelldebug(spell)
	end
    handle_equipping_gear(player.status)
    equip(sets.Idle.Current)    
end

function status_change(new,tab)
    handle_equipping_gear(player.status)
    if new == 'Resting' then
        equip(sets.Resting)
    else
        equip(sets.Idle.Current)
    end
	add_to_chat(8,'State Change:'..new)
end


function job_buff_change(status,gain_or_loss)
    handle_equipping_gear(player.status)
   if (gain_or_loss) then  
     add_to_chat(4,'------- Gained Buff: '..status..'-------')
	 if status == "sleep" then
	   equip(sets.WakeSleep)
	 end
	 if status == "KO" then
	   send_command('input /party These tears... they sting-wing....')
	 end
   else 
     add_to_chat(3,'------- Lost Buff: '..status..'-------')
   end
 end




function job_state_change(stateField, newValue, oldValue)
    job_handle_equipping_gear(player.status)
	equip(sets.Idle.Current)
	add_to_chat(8,'State Change:'..newValue)
end


function job_handle_equipping_gear(playerStatus, eventArgs)    	
	disable_specialgear()
    if buffactive.sleep then
		equip(sets.WakeSleep)
		add_to_chat(3,'Equipping Sleep Gear')
	end
end



function select_default_macro_book()
    set_macro_page(1, 1)
end
