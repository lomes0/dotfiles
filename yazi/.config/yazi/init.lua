require("full-border"):setup()

function Status:render() return {} end

-- To get no title cwd
function Header:render(area)
	self.area = area

	-- local right = ui.Line { self:count(), self:tabs() }
	-- local left = ui.Line { self:cwd(math.max(0, area.w - right:width())) }
	-- local left = ui.Line { }
	return {
		-- ui.Paragraph(area, { left }),
		-- ui.Paragraph(area, { right }):align(ui.Paragraph.RIGHT),
	}
end

-- To get no status line
local old_manager_render = Manager.render
function Manager:render(area)
	return old_manager_render(self, ui.Rect { x = area.x, y = area.y, w = area.w, h = area.h + 1 })
end
