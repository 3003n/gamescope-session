local winmini_lcd_refresh_rates = {
    60,
    80,
    90,
    100,
    110,
    120
}

local modelines = {
    [60] = {
        clock = 137.550,
        hsync_start = 1152,
        hsync_end = 1160,
        htotal = 116,
        vsync_start = 1933,
        vsync_end = 1936,
        vtotal = 1949
    },
    [80] = {
        clock = 317.645,
        hsync_start = 1230,
        hsync_end = 1290,
        htotal = 1410,
        vsync_start = 2780,
        vsync_end = 2786,
        vtotal = 2816
    },
    [90] = {
        clock = 318.012,
        hsync_start = 1230,
        hsync_end = 1290,
        htotal = 1410,
        vsync_start = 2470,
        vsync_end = 2476,
        vtotal = 2506
    },
    [100] = {
        clock = 312.660,
        hsync_start = 1170,
        hsync_end = 1230,
        htotal = 1350,
        vsync_start = 2280,
        vsync_end = 2286,
        vtotal = 2316
    },
    [110] = {
        clock = 309.029,
        hsync_start = 1170,
        hsync_end = 1230,
        htotal = 1350,
        vsync_start = 2045,
        vsync_end = 2051,
        vtotal = 2081
    },
    [120] = {
        clock = 321.750,
        hsync_start = 1170,
        hsync_end = 1230,
        htotal = 1350,
        vsync_start = 1950,
        vsync_end = 1956,
        vtotal = 1986
    }
}

gamescope.config.known_displays.gpd_winmini2023_lcd = {
    pretty_name = "GPD Win Mini 2023",
    
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

    dynamic_refresh_rates = winmini_lcd_refresh_rates,

    dynamic_modegen = function(base_mode, refresh)
        info("Generating mode " .. refresh .. "Hz for GPD Win Mini 2023 with fixed pixel clock")
        info("base_mode: " .. inspect(base_mode))

        local modeline = modelines[refresh]
        if modeline == nil then
            warn("Couldn't do refresh " .. refresh .. " on GPD Win Mini")
            return base_mode
        end

        local mode = base_mode

        gamescope.modegen.set_resolution(mode, 1080, 1920)

        -- mode.clock = modeline.clock * 1000

        mode.hsync_start = modeline.hsync_start
        mode.hsync_end = modeline.hsync_end
        mode.htotal = modeline.htotal

        mode.vsync_start = modeline.vsync_start
        mode.vsync_end = modeline.vsync_end
        mode.vtotal = modeline.vtotal

        mode.clock = gamescope.modegen.calc_max_clock(mode, refresh)
        mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)

        info("mode: " .. inspect(mode))
        return base_mode
    end,

    matches = function(display)
        info("[TEST] vendor: " .. display.vendor .. " model: " .. display.model .. " product:" .. display.product)
        if display.vendor == "GPD" and display.model == "MINI" then
            debug(
                "[gpd_winmini2023_lcd] Matched vendor: " ..
                    display.vendor .. " model: " .. display.model .. " product:" .. display.product
            )
            return 5000
        end
        return -1
    end
}
info("Registered GPD Win Mini 2023 as a known display")
info(inspect(gamescope.config.known_displays.gpd_winmini2023_lcd))
