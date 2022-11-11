local Elements = {itable = {}}

---@param element Element
function Elements:add(element)
	if not element.id then
		msg.error('attempt to add element without "id" property')
		return
	end

	if self:has(element.id) then Elements:remove(element.id) end

	self.itable[#self.itable + 1] = element
	self[element.id] = element

	request_render()
end

function Elements:remove(idOrElement)
	if not idOrElement then return end
	local id = type(idOrElement) == 'table' and idOrElement.id or idOrElement
	local element = Elements[id]
	if element then
		if not element.destroyed then element:destroy() end
		element.enabled = false
		self.itable = itable_remove(self.itable, self[id])
		self[id] = nil
		request_render()
	end
end

function Elements:update_proximities()
	local capture_mbtn_left = false
	local capture_wheel = false
	local menu_only = Elements.menu ~= nil
	local mouse_leave_elements = {}
	local mouse_enter_elements = {}

	-- Calculates proximities and opacities for defined elements
	for _, element in self:ipairs() do
		if element.enabled then
			local previous_proximity_raw = element.proximity_raw

			-- If menu is open, all other elements have to be disabled
			if menu_only then
				if element.ignores_menu then
					capture_mbtn_left = true
					capture_wheel = true
					element:update_proximity()
				else
					element.proximity_raw = infinity
					element.proximity = 0
				end
			else
				element:update_proximity()
			end

			-- Element has global forced key listeners
			if element.on_global_mbtn_left_down then capture_mbtn_left = true end
			if element.on_global_wheel_up or element.on_global_wheel_down then capture_wheel = true end

			if element.proximity_raw == 0 then
				-- Element has local forced key listeners
				if element.on_mbtn_left_down then capture_mbtn_left = true end
				if element.on_wheel_up or element.on_wheel_up then capture_wheel = true end

				-- Mouse entered element area
				if previous_proximity_raw ~= 0 then
					mouse_enter_elements[#mouse_enter_elements + 1] = element
				end
			else
				-- Mouse left element area
				if previous_proximity_raw == 0 then
					mouse_leave_elements[#mouse_leave_elements + 1] = element
				end
			end
		end
	end

	-- Enable key group captures requested by elements
	mp[capture_mbtn_left and 'enable_key_bindings' or 'disable_key_bindings']('mbtn_left')
	mp[capture_wheel and 'enable_key_bindings' or 'disable_key_bindings']('wheel')

	-- Trigger `mouse_leave` and `mouse_enter` events
	for _, element in ipairs(mouse_leave_elements) do element:trigger('mouse_leave') end
	for _, element in ipairs(mouse_enter_elements) do element:trigger('mouse_enter') end
end

-- Toggles passed elements' min visibilities between 0 and 1.
---@param ids string[] IDs of elements to peek.
function Elements:toggle(ids)
	local has_invisible = itable_find(ids, function(id) return Elements[id] and Elements[id].min_visibility ~= 1 end)
	self:set_min_visibility(has_invisible and 1 or 0, ids)
end

-- Set (animate) elements' min visibilities to passed value.
---@param visibility number 0-1 floating point.
---@param ids string[] IDs of elements to peek.
function Elements:set_min_visibility(visibility, ids)
	for _, id in ipairs(ids) do
		local element = Elements[id]
		if element then element:tween_property('min_visibility', element.min_visibility, visibility) end
	end
end

-- Flash passed elements.
---@param ids string[] IDs of elements to peek.
function Elements:flash(ids)
	local elements = itable_filter(self.itable, function(element) return itable_index_of(ids, element.id) ~= nil end)
	for _, element in ipairs(elements) do element:flash() end
end

---@param name string Event name.
function Elements:trigger(name, ...)
	for _, element in self:ipairs() do element:trigger(name, ...) end
end

-- Trigger two events, `name` and `global_name`, depending on element-cursor proximity.
-- Disabled elements don't receive these events.
---@param name string Event name.
function Elements:proximity_trigger(name, ...)
	for _, element in self:ipairs() do
		if element.enabled then
			if element.proximity_raw == 0 then element:trigger(name, ...) end
			element:trigger('global_' .. name, ...)
		end
	end
end

function Elements:has(id) return self[id] ~= nil end
function Elements:ipairs() return ipairs(self.itable) end

---@param name string Event name.
function Elements:create_proximity_dispatcher(name)
	return function(...) self:proximity_trigger(name, ...) end
end

mp.set_key_bindings({
	{
		'mbtn_left',
		Elements:create_proximity_dispatcher('mbtn_left_up'),
		function(...)
			update_mouse_pos(nil, mp.get_property_native('mouse-pos'), true)
			Elements:proximity_trigger('mbtn_left_down', ...)
		end,
	},
	{'mbtn_left_dbl', 'ignore'},
}, 'mbtn_left', 'force')

mp.set_key_bindings({
	{'wheel_up', Elements:create_proximity_dispatcher('wheel_up')},
	{'wheel_down', Elements:create_proximity_dispatcher('wheel_down')},
}, 'wheel', 'force')

return Elements
