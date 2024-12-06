local winmini_lcd_refresh_rates = {}
for i = 61, 120 do
    table.insert(winmini_lcd_refresh_rates, i)
end

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
    -- Use the EDID colorimetry for now, but someone should check
    -- if the EDID colorimetry truly matches what the display is capable of.
    dynamic_refresh_rates = winmini_lcd_refresh_rates,
    -- Follow the Steam Deck OLED style for modegen by variang the VFP (Vertical Front Porch)
    --
    -- Given that this display is VRR and likely has an FB/Partial FB in the DDIC:
    -- it should be able to handle this method, and it is more optimal for latency
    -- than elongating the clock.
    dynamic_modegen = function(base_mode, refresh)
        debug("Generating mode " .. refresh .. "Hz for GPD Win Mini 2023")
        local vfps = {
            4002, 3857, 3718, 3586, 3460, 
            3340, 3225, 3114, 3009, 2907, 
            2810, 2717, 2627, 2540, 2457, 
            2377, 2299, 2225, 2153, 2083, 
            2016, 1951, 1888, 1827, 1767, 
            1710, 1655, 1601, 1548, 1498, 
            1448, 1400, 1354, 1308, 1264, 
            1221, 1179, 1139, 1099, 1060, 
            1023, 986, 950, 915, 881, 
            847, 815, 783, 752, 721, 
            692, 663, 634, 606, 579, 
            552, 526, 501, 475, 451, 
            427, 403, 380, 357, 335, 
            313, 292, 271, 250, 230, 
            210, 191, 171, 153, 134, 
            116, 98, 81, 63, 46, 30
        }
        local vfp = vfps[zero_index(refresh - 40)]
        if vfp == nil then
            warn("Couldn't do refresh "..refresh.." on GPD Win Mini")
            return base_mode
        end
        debug("vfp:"..vfp)

        local mode = base_mode

        gamescope.modegen.adjust_front_porch(mode, vfp)
        mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)

        debug(inspect(mode))
        return mode
    end,


    matches = function(display)
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
debug("Registered GPD Win Mini 2023 as a known display")
-- debug(inspect(gamescope.config.known_displays.gpd_winmini2023_lcd))
