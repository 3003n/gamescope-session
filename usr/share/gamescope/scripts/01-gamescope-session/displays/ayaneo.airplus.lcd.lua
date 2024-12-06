local airplus_lcd_refresh_rates = {}
for i = 45, 60 do
    table.insert(airplus_lcd_refresh_rates, i)
end

gamescope.config.known_displays.ayaneo_airplus_lcd = {
    pretty_name = "AYANEO AIR Plus/SLIDE",

    hdr = {
        -- Setup some fallbacks for undocking with HDR, meant
        -- for the internal panel. It does not support HDR.
        supported = false,
        force_enabled = false,
        eotf = gamescope.eotf.gamma22,
        max_content_light_level = 500,
        max_frame_average_luminance = 500,
        min_content_light_level = 0.5
    },

    dynamic_refresh_rates = airplus_lcd_refresh_rates,

    dynamic_modegen = function(base_mode, refresh)
        info("Generating mode " .. refresh .. "Hz for AYANEO AIR Plus/SLIDE with fixed pixel clock")
        info("base_mode: " .. inspect(base_mode))

        local mode = base_mode

        gamescope.modegen.set_resolution(mode, 1080, 1920)

        -- hfp, hsync, hbp
        gamescope.modegen.set_h_timings(mode, 116, 4, 34)
        -- vfp, vsync, vbp
        gamescope.modegen.set_v_timings(mode, 20, 2, 6)
        mode.clock = gamescope.modegen.calc_max_clock(mode, refresh)
        mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)

        info("mode: " .. inspect(mode))
        return base_mode
    end,

    matches = function(display)
        local lcd_types = {
            {vendor = "AYA", model = "AYANEOHD"},
            {vendor = "AUS", model = ""}
        }
        
        for _, lcd_type in ipairs(lcd_types) do
            if display.vendor == lcd_type.vendor and "" .. display.model == lcd_type.model then
                debug(
                    "[ayaneo_airplus_lcd] Matched vendor: " ..
                        display.vendor .. " model: " .. display.model .. " product:" .. display.product
                )
                return 5000
            end
        end
        return -1
    end
}
info("Registered AYANEO AIR Plus/SLIDE as a known display")
info(inspect(gamescope.config.known_displays.ayaneo_airplus_lcd))
